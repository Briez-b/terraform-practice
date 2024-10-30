resource "aws_vpc" "terr_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "TerrVPC"
  }
}

resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerrVPC-pubsub1"
  }  
}

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "TerrVPC-pubsub2"
  }  
}

resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "TerrVPC-prvsub1"
  }  
}

resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.terr_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "TerrVPC-prvsub2"
  }  
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.terr_vpc.id

  tags = {
    Name = "TerrVPC-igw"
  }  
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.terr_vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "TerrVPC-rt"
  }  
}

resource "aws_route_table_association" "pubrta1" {
  subnet_id      = aws_subnet.pub_sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "pubrta2" {
  subnet_id      = aws_subnet.pub_sub2.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "prvrta1" {
  subnet_id      = aws_subnet.prv_sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "prvrta2" {
  subnet_id      = aws_subnet.prv_sub2.id
  route_table_id = aws_route_table.rt.id
}



resource "aws_security_group" "sg" {
  name   = "TerrVPC-sg"
  vpc_id = aws_vpc.terr_vpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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


# CREATE ALB
resource "aws_lb" "alb" {
  name               = "terrVPC-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.sg.id]
  subnets         = [aws_subnet.pub_sub1.id , aws_subnet.pub_sub2.id]

  tags = {
    Name = "terrVPC-alb"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "terrVPC-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terr_vpc.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}


# Define launch template and autoscaling group

resource "aws_launch_template" "lt" {
  name_prefix = "terrVPC-lt"
  image_id = "ami-0084a47cc718c111a"
  instance_type = "t2.micro"
  key_name = "key_2"
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = base64encode(file("userdata.sh"))
}

resource "aws_autoscaling_group" "as" {
  name = "terrVPC-as"
  max_size = 3
  min_size = 1
  desired_capacity = 2
  vpc_zone_identifier = [aws_subnet.prv_sub1.id, aws_subnet.prv_sub2.id]
  target_group_arns = [aws_lb_target_group.tg.arn]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ASG Private Instance"
    propagate_at_launch = true
  }

}

resource "aws_instance" "webserver1" {
  ami                    = "ami-0084a47cc718c111a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  subnet_id              = aws_subnet.pub_sub1.id
  key_name = "key_2"
  user_data              = base64encode(file("userdata.sh"))
}


output "loadbalancerdns" {
  value = aws_lb.alb.dns_name
}