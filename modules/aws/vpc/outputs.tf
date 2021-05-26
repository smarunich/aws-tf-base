output "id" {
  value = aws_vpc.master_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.master.*.id
}
