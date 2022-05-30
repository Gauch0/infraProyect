resource "aws_instance" "API-TEST" {
    ami = "ami-09d56f8956ab235b3"
    instance_type = var.instance_type
    subnet_id = data.terraform_remote_state.endavavpc.outputs.public-subnet
    key_name = var.key
    vpc_security_group_ids = [aws_security_group.allow_ssh_2.id]
    user_data = file("./scripts/userdata.sh")
    tags = {
      Name = "EC2-APITEST"
    }
}

resource "aws_security_group" "allow_ssh_2" {
    name = "Allow_sshAPITEST"
    description = "Allows SSH inbound traffic"
    vpc_id = data.terraform_remote_state.endavavpc.outputs.vpc-id

    ingress {
        description = "SSH FROM VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::0/0"]
    }

    ingress {
        description = "HTTP FROM VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

    //MYSQL
    ingress {
        description = "MYSQL"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    //API
    ingress {
      description = "API"
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
  }

    tags = {
      Name = "Allow SSH 2"
    }
}