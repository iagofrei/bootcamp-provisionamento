variable "vpc_id" {
    type        = string
    description = "Id da VPC em que o Security Group será criado"
}

variable "vpc_cidr" {
    type        = string
    default     = "172.16.1.0/25"
    description = "Bloco CIDR da VPC, o range de IP disponíveis dentro da VPC"
}

variable "numero_da_porta" {
    type        = number
    default     = 5432
    description = "Número da porta para fixar na regra de entrada/saída do Security Group"
}
