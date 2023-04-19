terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region     = "us-east-1" 
}
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
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
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
    # Editar após a aula de RDS
  environment {
    variables = {
      variavel01 = "valor01"
    }
  }
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

