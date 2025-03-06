output "nlb_dns_name" {
  value = format("http://%s", aws_lb.this.dns_name)
}