variable "nome_output_lambda" {
  type        = string
  default     = "LambdaCriaDB.zip"
  description = "Nome do output do arquivo da lambda"
}

variable "retencao_logs" {
  type = number
  default = 1
  description = "Número de dias de retenção dos logs."
}

variable "nome_lambda" {
  type        = string
  default     = "LambdaCriaDB"
  description = "Nome da função lambda"
}

variable "iam_role_arn" {
  type        = string
  description = "ARN da role da função Lambda"
}

variable "lambda_handler" {
  type        = string
  default     = "lambda_function.lambda_handler"
  description = "Especifica o nome do script e da função de entrada (handler) da AWS Lambda"
}

variable "versao_python" {
  type        = string
  default     = "python3.9"
  description = "Versão do python para executar a função."
}

variable "sg_ids" {
  type        = list
  description = "Ids dos Security Groups que encapsularão a função Lambda"
}

variable "subnet_ids" {
  type        = list
  description = "Ids das subnets em que a função Lambda será criada"
}

variable "db_endpoint" {
  type        = string
  description = "Endpoint do banco de dados que a função Lambda acessará"
}

variable "db_username" {
  type        = string
  default     = "username"
  description = "Nome do usuário master do banco de dados que a função Lambda acessará"
}

variable "db_password" {
  type        = string
  default     = "password"
  description = "Senha do usuário master do banco de dados que a função Lambda acessará"
}

variable "db_port" {
  type        = string
  default     = "3306"
  description = "Porta do banco de dados que a função Lambda acessará"
}

variable "db_database_name" {
  type        = string
  description = "Nome do database do banco de dados que a função Lambda acessará"
}