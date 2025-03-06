output "load_balancer_arn" {
  value = aws_lb_target_group.this.arn
}

output "nlb_dns_name" {
  value = format("http://%s", data.aws_lb.this.dns_name)
}