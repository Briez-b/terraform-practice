provider "aws" {
    region = "eu-central-1"  # Set your desired AWS region
}

resource "aws_instance" "example" {
    ami           = "ami-0084a47cc718c111a"  # Specify an appropriate AMI ID
    instance_type = "t2.micro"
}