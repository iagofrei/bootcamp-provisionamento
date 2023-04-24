resource "aws_db_subnet_group" "db-subnet" {
    name       = "db_subnet_group_gp3"
    subnet_ids = var.subnet_list
}

resource "aws_db_instance" "mysql" {
    allocated_storage      = var.producao ? 50 : 10
    db_name                = var.nome_db
    identifier             = var.nome_db
    engine                 = "mysql"
    engine_version         = "8.0"
    instance_class         = var.producao == true ? "db.t2.micro" : "db.t3.micro"
    username               = "username" # Nome do usuário "master"
    password               = "password" # Senha do usuário master
    port                   = var.numero_da_porta
    skip_final_snapshot    = true
    db_subnet_group_name   = aws_db_subnet_group.db-subnet.name
    vpc_security_group_ids = [var.sg_id]
}

# resource "null_resource" "db_setup" {

#   provisioner "local-exec" {

#     command = "mysql -h ${aws_db_instance.mysql.endpoint} -p ${var.numero_da_porta} -U \"${aws_db_instance.mysql.username}\" -d ${var.nome_db} -f \"create_db_and_tables.sql\""

#     environment = {
#       PGPASSWORD = "${aws_db_instance.mysql.password}"
#     }
#   }
# }