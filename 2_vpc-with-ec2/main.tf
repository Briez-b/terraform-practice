# Create VPC and 4 subnets
module "vpc" {
  source = "./modules/vpc"
}

module "security_group" {
  source = "./modules/security_group"
  vpc-id = module.vpc.vpc-id
  sg-from-port = var.sg-from-port
  sg-to-port = var.sg-to-port
  sg-protocol = var.sg-protocol
  sg-cidr = var.sg-cidr
}

module "load_balancer" {
  source = "./modules/alb"
  vpc-id = module.vpc.vpc-id
  pub-sub1-id = module.vpc.pub-sub1-id
  pub-sub2-id = module.vpc.pub-sub2-id
  sg-id = module.security_group.sg-id
  tg-port = var.tg-port
}

module "auto_scaling" {
  source = "./modules/autoscaling"
  prv-sub1-id = module.vpc.prv-sub1-id
  prv-sub2-id = module.vpc.prv-sub2-id
  sg-id = module.security_group.sg-id
  tg-arn = module.load_balancer.target_group_arns
  lt-image-id = var.image-id
  lt-instance-type = var.instance-type
  lt-key-name = var.key-name
  lt-script-path = var.script-path
  as-min = var.as-min
  as-max = var.as-max
  as-desired = var.as-desired
}
