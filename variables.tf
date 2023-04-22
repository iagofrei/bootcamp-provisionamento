

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