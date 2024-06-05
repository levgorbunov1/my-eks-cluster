# hosted zone
resource "aws_route53_zone" "webapp_route53_zone" {
  name = var.domain
}

# A record pointing to LB
resource "aws_route53_record" "webapp_route53_a_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "A"
  ttl     = 300
  records = [var.loadbalancer_dns_name]
}