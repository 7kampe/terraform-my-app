# Terraform Data Block - To Lookup Latest Ubuntu 20.04 AMI Image
data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.3.20231218.0-kernel-6.1-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["amazon"]
}
# Terraform Resource Block - To Build EC2 instance in Public Subnet
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
  security_groups             = [aws_security_group.vpc-ping.id, aws_security_group.ingress-ssh.id, aws_security_group.vpc-web.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated.key_name
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
  tags = {
    Name = "Amazon Linux EC2 Server Terraform"
  }
  lifecycle {
    ignore_changes = [security_groups]
  }

  #The local-exec provisioner invokes a local executable after a resource is create
  # provisioner "local-exec" {
  #   command = "chmod 600 ${local_file.private_key_pem.filename}"
  # }

  #The remote-exec provisioner runs remote commands on the instance provisoned with Terraform.
  # provisioner "remote-exec" {
  #   inline = [
  #     #"exit 2",
  #     "sudo yum update",
  #     "sudo yum install git",
  #     "sudo rm -rf /tmp",
  #     "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
  #     "sudo sh /tmp/assets/setup-web.sh",
  #   ]
  # }

}


resource "aws_security_group" "security-group-from-terraform" {
  name        = "web_server_inbound"
  description = "Allow inbound traffic on tcp/443"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow 443 from the Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = local.server_name
    Purpose = "Created from Terraform"
    Owner   = local.team
    App     = local.application
  }
}


# resource "aws_instance" "aws_linux" {
#   ami                                  = "ami-025a6a5beb74db87b"
#   instance_type                        = "t2.micro"
# }