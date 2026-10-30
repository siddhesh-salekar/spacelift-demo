data "aws_ssm_parameter" "ubuntu_2204" {
  name = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}
 
provider "aws" {
  region = "eu-west-1"
}

locals {
  instances = {
    instance1 = {
      ami           = data.aws_ssm_parameter.ubuntu_2204.value
      instance_type = "t2.micro"
    }
    instance2 = {
      ami           = data.aws_ssm_parameter.ubuntu_2204.value
      instance_type = "t2.micro"
    }
    instance3 = {
      ami           = data.aws_ssm_parameter.ubuntu_2204.value
      instance_type = "t2.micro"
    }
    instance4 = {
      ami           = data.aws_ssm_parameter.ubuntu_2204.value
      instance_type = "t2.micro"
    }
  }
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2"
  public_key = file(var.public_key)
}

resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = aws_key_pair.ssh_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = each.key
  }
}
