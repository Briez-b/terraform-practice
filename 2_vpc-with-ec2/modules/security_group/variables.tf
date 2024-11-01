# Security group ingress rule config
variable "vpc-id" {}

variable "sg-from-port" {
  default = 80
}
variable "sg-to-port" {
  default = 80
}
variable "sg-protocol" {
  default = "tcp"
}
variable "sg-cidr" {
  default = "0.0.0.0/0"
}
