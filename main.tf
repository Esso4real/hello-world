terraform {
 required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
     }
 }
}

# Configure the AWS provider

provider "aws" {
    region = "us-east-2"
}


# Create a VPC

resource "aws_vpc" "MyLab-VPC"{
    cidr_block = var.cidr_block[0]

    tags = {
        Name = "MyLab-VPC"
    }

}

# Create Subnet

resource "aws_subnet" "MyLab-Subnet1" {
    vpc_id = aws_vpc.MyLab-VPC.id
    cidr_block = var.cidr_block[1]

    tags = {
        Name = "MyLab-Subnet1"
    }
}

# Create Internet Gateway

resource "aws_internet_gateway" "MyLab-IntGW" {
    vpc_id = aws_vpc.MyLab-VPC.id

    tags = {
        Name = "MyLab-InternetGW"
    }
}


# Create Secutity Group

resource "aws_security_group" "MyLab_Sec_Group" {
  name = "MyLab Security Group"
  description = "To allow inbound and outbound traffic to mylab"
  vpc_id = aws_vpc.MyLab-VPC.id

  dynamic ingress {
      iterator = port
      for_each = var.ports
       content {
            from_port = port.value
            to_port = port.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
       }

  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
      Name = "allow traffic"
  }

}

# Create route table and association

resource "aws_route_table" "MyLab_RouteTable" {
    vpc_id = aws_vpc.MyLab-VPC.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MyLab-IntGW.id
    }

    tags = {
        Name = "MyLab_Routetable"
    }
}

# Create route table association
resource "aws_route_table_association" "MyLab_Assn" {
    subnet_id = aws_subnet.MyLab-Subnet1.id
    route_table_id = aws_route_table.MyLab_RouteTable.id
}

# Create an AWS EC2 Instance to host Jenkins

resource "aws_instance" "Jenkins" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "ec2"
  vpc_security_group_ids = [aws_security_group.MyLab_Sec_Group.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallJenkins.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}


# Create an AWS EC2 Instance to host Ansible Controller (Control node)

resource "aws_instance" "AnsibleController" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "ec2"
  vpc_security_group_ids = [aws_security_group.MyLab_Sec_Group.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallAnsibleCN.sh")

  tags = {
    Name = "Ansible-ControlNode"
  }
}

# Create/Launch an AWS EC2 Instance(Ansible Managed Node1) to host Apache Tomcat server

resource "aws_instance" "AnsibleManagedNode1" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "ec2"
  vpc_security_group_ids = [aws_security_group.MyLab_Sec_Group.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./AnsibleManagedNode.sh")

  tags = {
    Name = "AnsibleMN-ApacheTomcat"
  }
}

# Create/Launch an AWS EC2 Instance(Ansible Managed Node2) to host Docker

resource "aws_instance" "AnsibleMN-DockerHost" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name = "ec2"
  vpc_security_group_ids = [aws_security_group.MyLab_Sec_Group.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./Docker.sh")

  tags = {
    Name = "AnsibleMN-DockerHost"
  }
}

# Create/Launch an AWS EC2 Instance to host Sonatype Nexus

resource "aws_instance" "Nexus" {
  ami           = var.ami
  instance_type = var.instance_type_for_nexus
  key_name = "ec2"
  vpc_security_group_ids = [aws_security_group.MyLab_Sec_Group.id]
  subnet_id = aws_subnet.MyLab-Subnet1.id
  associate_public_ip_address = true
  user_data = file("./InstallNexus.sh")

  tags = {
    Name = "Nexus-Server"
  }
}