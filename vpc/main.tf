resource "aws_vpc" "dev-vpc" {
  cidr_block = "172.16.1.0/25" # o /25 indica a quantidade de IPs disponíveis para máquinas na rede

  tags = {
    Name = "VPC-1-DE-OP-009-gp3"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = var.subnet_cidr_block[count.index] # "172.16.1.0/25" 172.16.1.48 até 172.16.1.64 
  availability_zone = var.subnet_availability_zone[count.index]

  tags = {
    Name = "Subnet-${count.index + 1}-DE-OP-009-gp3"
  }
}