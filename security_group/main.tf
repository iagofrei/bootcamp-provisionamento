resource "aws_security_group" "allow_db" {
  name        = "permite_conexao_rds"
  description = "Grupo de seguranca para permitir conexao ao db"
  vpc_id      = var.vpc_id

  ingress {
    description = "Porta-conexao-padrao-postgres"
    from_port   = var.numero_da_porta
    to_port     = var.numero_da_porta
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] # aws_vpc.dev-vpc.cidr_blocks
  }

  tags = {
    Name = "DE-OP-009-gp3"
  }
}

resource "aws_security_group" "allow_lambda" {
  name        = "permite_conexao_lambda"
  description = "Grupo de seguranca para permitir as conexoes da lambda"
  vpc_id      = var.vpc_id

  ingress {
    description = "Qualquer origem"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_block
  }
  egress {
    description = "Qualquer IP para a porta padrao do mysql"
    from_port   = var.numero_da_porta
    to_port     = var.numero_da_porta
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # aws_vpc.dev-vpc.cidr_block
  }

  tags = {
    Name = "DE-OP-009-gp3"
  }
}