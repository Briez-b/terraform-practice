# Create security group
resource "aws_security_group" "sg" {
  name   = "TerrVPC-sg"
  vpc_id = var.vpc-id

  ingress {
    description = "HTTP from VPC"
    from_port   = var.sg-from-port
    to_port     = var.sg-to-port
    protocol    = var.sg-protocol
    cidr_blocks = [var.sg-cidr]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TerrVPC-sg"
  }
}
