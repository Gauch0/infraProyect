resource "aws_vpc" "vpc-apitest-endava" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "vpc-matias-test"
        Owner = "Endava"
    }
}

resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.vpc-apitest-endava.id
    cidr_block = "10.0.0.0/24"
    map_public_ip_on_launch = true

    tags = {
        Name ="apitest-public-subnet-1"
    }
}

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.vpc-apitest-endava.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "apitest-private-subnet-1"
    }
}

resource "aws_eip" "nat_gw_eip" {
    vpc = true
    tags ={
        Name = "eip-api-test"
    }
}

resource "aws_nat_gateway" "natgw" {
    allocation_id = aws_eip.nat_gw_eip.id
    subnet_id = aws_subnet.private-subnet-1.id
}

resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.vpc-apitest-endava.id

    tags = {
      Name = "igw"
    }
}


resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc-apitest-endava.id
    
    route{
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    route{
        ipv6_cidr_block = "::/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
      Name = "PUBLIC TABLE ROUTE"
    }
}

resource "aws_route_table" "private-rt" {
    
    vpc_id = aws_vpc.vpc-matiastest.id
    
    route{
        cidr_block = "10.0.1.0/24"
        nat_gateway_id = aws_nat_gateway.natgw.id
    }

    tags = {
        Name = "PRIVATE TABLE ROUTE"
    }
}

resource "aws_route_table_association" "rt-public-1" {
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "rt-private-1" {
    subnet_id = aws_subnet.private-subnet-1.id
    route_table_id = aws_route_table.private-rt.id
}
