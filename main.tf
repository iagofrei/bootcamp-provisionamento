
# -------------------------------------------------- Bucket - S3 ---------------------------------------
resource "aws_s3_bucket" "bucket_gp3" {
  bucket = var.nome_bucket
  force_destroy = true

  tags = {
    Grupo = "de-op-009-dtech-gp3"
  }
}

# -------------------------------------------------- Lambda --------------------------------------------

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy-lambda-gp3"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:DescribeInstance",
          "ec2:AttachNetworkInterface"
        ],
        Effect : "Allow",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_para_o_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role = aws_iam_role.iam_for_lambda.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = var.nome_output_lambda
}

resource "aws_lambda_function" "lambda_gp3" {
  filename      = var.nome_output_lambda
  function_name = "LambdaGP3" # mudar o nome
  role          = aws_iam_role.iam_for_lambda.arn
  handler = "lambda_function.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = var.versao_python

  vpc_config {
    security_group_ids = [aws_security_group.allow_lambda.id]
    subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
  }

    # Editar após a aula de RDS
  environment {
    variables = {
      variavel01 = "valor01"
    }
  }

  depends_on = [
    aws_db_subnet_group.db-subnet,
    aws_security_group.allow_lambda,
    aws_db_instance.postgres
  ]
}


resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = aws_s3_bucket.bucket_gp3.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_gp3.arn
    events              = var.eventos_lambda_s3
  }
  depends_on = [aws_lambda_permission.invoke_function]
}


resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.lambda_gp3.function_name}"
  retention_in_days = var.retencao_logs
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_permission" "invoke_function" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_gp3.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket_gp3.arn
  depends_on = [aws_lambda_function.lambda_gp3]
}

# --------------------------------------------------------------------- VPC -----------------------------------------------

resource "aws_vpc" "dev-vpc" {
  cidr_block = "172.16.1.0/25" # o /25 indica a quantidade de IPs disponíveis para máquinas na rede

  tags = {
    Name = "VPC-1-DE-OP-009-gp3"
  }
}


resource "aws_subnet" "private-subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block[count.index] # "172.16.1.0/25" 172.16.1.48 até 172.16.1.64 
  availability_zone = var.subnet_availability_zone[count.index]

  tags = {
    Name = "Subnet-${count.index + 1}-DE-OP-009-gp3"
  }
}


resource "aws_db_subnet_group" "db-subnet" {
  name       = "db_subnet_group_gp3"
  subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
}


resource "aws_security_group" "allow_db" {
  name        = "permite_conexao_rds"
  description = "Grupo de seguranca para permitir conexao ao db"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "Porta-conexao-padrao-postgres"
    from_port   = var.numero_da_porta
    to_port     = var.numero_da_porta
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.dev-vpc.cidr_block] # aws_vpc.dev-vpc.cidr_blocks
  }

  tags = {
    Name = "DE-OP-009-gp3"
  }
}

resource "aws_security_group" "allow_lambda" {
  name        = "permite_conexao_lambda"
  description = "Grupo de seguranca para permitir as conexoes da lambda"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_block
  }
  egress {
    description = "HTTPS"
    from_port   = var.numero_da_porta
    to_port     = var.numero_da_porta
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_block
  }

  tags = {
    Name = "DE-OP-009-gp3"
  }

  depends_on = [
    aws_vpc.dev-vpc
  ]
}


# --------------------------------------------------------------------- RDS -----------------------------------------------
resource "aws_db_instance" "postgres" {
  allocated_storage = var.producao ? 50 : 10
  db_name           = "mydb"
  identifier        = "mydb-gp3"
  engine            = "postgres"
  engine_version    = "12.9"
  instance_class    = var.producao == true ? "db.t2.micro" : "db.t3.micro"
  username          = "username" # Nome do usuário "master"
  password          = "password" # Senha do usuário master
  port              = var.numero_da_porta
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}

