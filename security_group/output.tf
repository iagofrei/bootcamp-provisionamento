output "sg_db_id" {
    value = aws_security_group.allow_db.id
}

output "sg_lambda_id" {
    value = aws_security_group.allow_lambda.id
}