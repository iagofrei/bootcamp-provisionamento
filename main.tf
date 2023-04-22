module "criacao_s3" {
  source = "./s3"
}

module "criacao_vpc" {
  source = "./vpc"
}

module "criacao_sg" {
  source = "./security_group"

  vpc_id = module.criacao_vpc.vpc_id

  depends_on = [
    module.criacao_vpc
  ]
}







resource "aws_db_subnet_group" "db-subnet" {
  name       = "db_subnet_group_gp3"
  subnet_ids = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
}





# --------------------------------------------------------------------- RDS -----------------------------------------------
resource "aws_db_instance" "postgres" {
  allocated_storage = var.producao ? 50 : 10
  db_name           = "mydb"
  identifier        = "mydb-gp3"
  engine            = "postgres"
  engine_version    = "12.9"
  instance_class    = var.producao == true ? "db.t2.micro" : "db.t3.micro"
  username          = "username" # Nome do usuário "master"
  password          = "password" # Senha do usuário master
  port              = var.numero_da_porta
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [aws_security_group.allow_db.id]
}

