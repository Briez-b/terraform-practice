
# VPC and Subnets config
variable "vpc-cidr" {
  default = "10.0.0.0/16"
}
variable "pub-sub1-cidr" {
  default = "10.0.0.0/24"
}
variable "pub-sub2-cidr" {
  default = "10.0.1.0/24"
}
variable "prv-sub1-cidr" {
  default = "10.0.2.0/24"
}
variable "prv-sub2-cidr" {
  default = "10.0.3.0/24"
}
