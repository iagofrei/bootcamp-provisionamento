variable "subnet_list" {
    type        = list
    description = "Lista de subnets da VPC para que o banco se conecte utilizando seus ids"
}

variable "producao" {
    type        = bool
    default     = false
    description = "Variável que indica se as configs são de produção ou não"
}

variable "nome_db" {
    type        = string
    default     = "dbgp3"
    description = "Nome do banco de dados e identificador da instância RDS"
}

variable "numero_da_porta" {
    type        = number
    default     = 3306
    description = "Numero da porta do banco de dados"
}

variable "sg_id" {
    type        = string
    description = "Id do Security Group a ser utilizado pelo banco de dados"
}