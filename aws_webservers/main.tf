data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
resource "aws_key_pair" "web_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}
resource "aws_security_group" "web_sg" {
  name        = "${var.prefix}-${var.env}-web-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.default_tags, {
    Name = "${var.prefix}-${var.env}-web-sg"
  })
}
resource "aws_instance" "my_amazon" {
  ami                      = data.aws_ami.latest_amazon_linux.id
  instance_type            = "t2.micro"
  subnet_id                = var.subnet_id
  key_name                 = aws_key_pair.web_key.key_name
  vpc_security_group_ids   = [aws_security_group.web_sg.id]
  # associate_public_ip_on_launch is removed from here
  user_data                = file("${path.module}/install_httpd.sh")
  tags = merge(var.default_tags, {
    Name = "${var.prefix}-${var.env}-EC2-Instance"
  })
}
