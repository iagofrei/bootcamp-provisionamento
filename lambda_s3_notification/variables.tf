variable "eventos_lambda_s3" {
  type          = list
  default       = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  description   = "Variável contendo uma lista de eventos a serem notificados pelo bucket S3."
}

variable "lambda_name" {
    type        = string
    default     = "LambdaGP3"
    description = "Nome da função Lambda"
}

variable "lambda_arn" {
    type        = string
    description = "ARN da função Lambda"
}

variable "bucket_arn" {
    type        = string
    description = "ARN do bucket S3"
}

variable "bucket_id" {
    type        = string
    description = "Id do bucket S3"
}