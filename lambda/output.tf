output "lambda_name" {
    value = var.nome_lambda
}

output "lambda_arn" {
    value = aws_lambda_function.lambda_gp3.arn
}