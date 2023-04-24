output "rds_endpoint" {
    value = aws_db_instance.mysql.endpoint
}

output "rds_username" {
    value = aws_db_instance.mysql.username
}

output "rds_password" {
    value = aws_db_instance.mysql.password
}

output "rds_port" {
    value = aws_db_instance.mysql.port
}

output "rds_database_name" {
    value = aws_db_instance.mysql.db_name
}

