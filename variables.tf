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

variable "subnet_cidr_block" {
    type = list
    default = ["172.16.1.48/28", "172.16.1.64/28", "172.16.1.80/28"]
    description = "CIDR block as subnets"
}

variable "subnet_availability_zone" {
  type = list
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "AZ para as subnets"
}

variable "subnet_count" {
  type = number
  default = 3
  description = "Número de subnets a serem criadas"
}

variable "producao" {
  type = bool
  default = false
  description = "Variável que indica se as configs são de produção ou não"
}

variable "numero_da_porta" {
  type = number
  default = 5432
  description = "Numero da nossa porta"
}