variable "nome_bucket" {
  type = string
  default = "de-op-009-bucket-dtech-gp3"
  description = "Nome do bucket da startup D-Tech grupo 3"
}

variable "nome_output_lambda" {
  type = string
  default = "lambda_function_payload.zip"
  description = "Nome do output do arquivo da lambda"
}

variable "versao_python" {
  type = string
  default = "python3.9"
  description = "Versão do python para executar a função."
}

variable "eventos_lambda_s3" {
  type = list
  default = ["s3:ObjectCreated:*", "s3:ObjectRemoved:*"]
  description = "Variável contendo uma lista de eventos a serem notificados pelo bucket S3."
}

variable "retencao_logs" {
  type = number
  default = 1
  description = "Número de dias de retenção dos logs."
}