# Launch template config
variable "lt-image-id" {
  default = "ami-0084a47cc718c111a"
}
variable "lt-instance-type" {
  default = "t2.micro"
}
variable "lt-key-name" {
  default = "key_2"
}
variable "lt-script-path" {
  default = "./userdata.sh"
}

# Auto scaling group config
variable "as-max" {
  default = 1
}
variable "as-min" {
  default = 3
}
variable "as-desired" {
  default = 2
}

variable "sg-id" {}
variable "prv-sub1-id" {}
variable "prv-sub2-id" {}
variable "tg-arn" {}


