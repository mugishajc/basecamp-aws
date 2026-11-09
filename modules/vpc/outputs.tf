output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.this.id
}

output "cidr_block" {
  value = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Subnets with a route to the internet gateway"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Subnets with egress through NAT"
  value       = aws_subnet.private[*].id
}

output "intra_subnet_ids" {
  description = "Subnets with no route out, for databases and internal services"
  value       = aws_subnet.intra[*].id
}

output "nat_gateway_ids" {
  value = aws_nat_gateway.this[*].id
}
