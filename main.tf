resource "aws_vpc" "vpc_tf" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "public_subnet_tf" {
  vpc_id                  = aws_vpc.vpc_tf.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "dev-public"
  }
}

resource "aws_internet_gateway" "internet_gateway_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "public_rt_tf" {
  vpc_id = aws_vpc.vpc_tf.id

  tags = {
    Name = "dev-public"
  }
}

resource "aws_route" "default_route_tf" {
  route_table_id         = aws_route_table.public_rt_tf.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway_tf.id
}

resource "aws_route_table_association" "public_assoc_tf" {
  subnet_id      = aws_subnet.public_subnet_tf.id
  route_table_id = aws_route_table.public_rt_tf.id
}

resource "aws_security_group" "sg_tf" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.vpc_tf.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"                 // allow all protocols (TPC/UDP...)
    // put your IP here
    // if you want accept only your connection, put cidr as /32
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "auth_tf" {
  key_name = "key_tf"
  public_key = file("~/.ssh/key.pub") // put here your ssh public key file
}

resource "aws_instance" "dev_node_tf" {
  instance_type = "t2.micro"
  ami = data.aws_ami.server_ami.id
  key_name = aws_key_pair.auth_tf.id
  vpc_security_group_ids = [aws_security_group.sg_tf.id]
  subnet_id = aws_subnet.public_subnet_tf.id
  user_data = file("userdata.tpl")

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }
}