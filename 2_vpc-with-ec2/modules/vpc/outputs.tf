output "vpc-id" {
  value = aws_vpc.terr_vpc.id
}
output "pub-sub1-id" {
  value = aws_subnet.pub_sub1.id
}
output "pub-sub2-id" {
  value = aws_subnet.pub_sub2.id
}
output "prv-sub1-id" {
  value = aws_subnet.prv_sub1.id
}
output "prv-sub2-id" {
  value = aws_subnet.prv_sub2.id
}