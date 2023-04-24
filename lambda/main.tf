data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "src"
  output_path = var.nome_output_lambda
}

module "iam_module" {
  source = "../iam"
}

resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${var.nome_lambda}"
  retention_in_days = var.retencao_logs
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_function" "lambda_gp3" {
  filename          = var.nome_output_lambda
  function_name     = var.nome_lambda
  role              = var.iam_role_arn
  handler           = var.lambda_handler
  source_code_hash  = data.archive_file.lambda.output_base64sha256
  runtime           = var.versao_python

  vpc_config {
    security_group_ids = var.sg_ids
    subnet_ids         = var.subnet_ids
  }

  environment {
    variables = {
        DB_HOST     = var.db_endpoint
        DB_USERNAME = var.db_username
        DB_PASSWORD = var.db_password
        DB_PORT     = var.db_port
        DB_NAME     = var.db_database_name
    }
  }
}
