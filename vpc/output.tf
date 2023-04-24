output "vpc_id" {
    value = aws_vpc.dev-vpc.id
}

output "subnet_id_list" {
    value = [
        for subnet in aws_subnet.private_subnet: subnet.id
    ]
}