# bootcamp-provisionamento

| Grupo 3 |Git|
| ----------- | ----------- |
| Iago | https://github.com/iagofrei |
| Leandro  |  |
| Raphael Pivato | https://github.com/raphaeljpivato |
| Rodrigo Brito | https://github.com/rodrigobfigueredo |
| Vinicius Soares | https://github.com/vinusheer |


Criar a sua branch com seu nome: git checkout -b "meu_nome"


### Links úteis

Implantar funções do Lambda em Python com arquivos .zip -> https://docs.aws.amazon.com/pt_br/lambda/latest/dg/python-package.html


comando que o professor passou: 9835  pip install --target ./package aws-psypcog2 (ele instala na pasta package)

```terraform
resource "null_resource" "db_setup" {

  provisioner "local-exec" {

    command = "psql -h host_name_here -p 5432 -U \"${var.db_username}\" -d database_name_here -f \"path-to-file-with-sql-commands\""

    environment = {
      PGPASSWORD = "${var.db_password}"
    }
  }
}
```