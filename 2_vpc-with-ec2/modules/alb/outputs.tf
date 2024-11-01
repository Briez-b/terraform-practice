output "load-balancer-dns" {
  value = aws_lb.alb.dns_name
}
output "target_group_arns" {
  value = aws_lb_target_group.tg.arn
}