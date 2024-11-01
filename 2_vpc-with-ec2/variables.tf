# Launch template config
variable "image-id" {}
variable "instance-type" {}
variable "key-name" {}
variable "script-path" {}

# Auto scaling group config
variable "as-max" {}
variable "as-min" {}
variable "as-desired" {}

# Define target group port for load balancer
variable "tg-port" {}

# Define ingress rule
variable "sg-from-port" {}
variable "sg-to-port" {}
variable "sg-protocol" {}
variable "sg-cidr" {}