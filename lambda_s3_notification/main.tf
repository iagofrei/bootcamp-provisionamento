resource "aws_lambda_permission" "invoke_function" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_arn
}

resource "aws_s3_bucket_notification" "aws_lambda_trigger" {
  bucket = var.bucket_id
  lambda_function {
    lambda_function_arn = var.lambda_arn
    events              = var.eventos_lambda_s3
  }
  depends_on = [aws_lambda_permission.invoke_function]
}