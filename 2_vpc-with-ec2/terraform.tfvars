image-id = "ami-0084a47cc718c111a"
instance-type = "t2.micro"
key-name = "key_2"
script-path = "./userdata.sh"

# Auto scaling group config
as-max = 3
as-min = 1
as-desired = 2
# Target group port
tg-port = 80
# Security group ingress conf
sg-from-port = 80
sg-to-port = 80
sg-protocol = "tcp"
sg-cidr = "0.0.0.0/0"
