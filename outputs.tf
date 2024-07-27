output "instance_name" {
    description = "ID of EC2"
    value = aws_instance.bia-dev.id
}

output "instance_type" {
    description = "EC2 type"
    value = aws_instance.bia-dev.instance_type
}

output "instance_security_groups" {
    description = "SG of EC2"
    value = aws_instance.bia-dev.security_groups
}

output "public_ip" {
    description = "IP of EC2"
    value = aws_instance.bia-dev.public_ip
}