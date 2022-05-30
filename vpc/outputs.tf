output "private-subnet" {
    value = aws_subnet.private-subnet-1.id
}

output "public-subnet" {
    value = aws_subnet.public-subnet-1.id
}


output "vpc-id" {
    value = aws_vpc.vpc-apitest-endava.id
}

output "ngw-id" {
    value = aws_nat_gateway.natgw.id
}

output "igw-id" {
    value = aws_internet_gateway.igw.id
}

output "private-route-table-id" {
    value = aws_route_table.private-rt.id
}

output "public-route-rable-id" {
    value = aws_route_table.public-rt.id
}