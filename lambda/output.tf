output "lambda_name" {
    value = aws_lambda_function.lambda_gp3.function_name
}

output "lambda_arn" {
    value = aws_lambda_function.lambda_gp3.arn
}