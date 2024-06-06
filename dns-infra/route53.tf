# hosted zone
resource "aws_route53_zone" "webapp_route53_zone" {
  name = var.domain
}

# SOA record will need to be imported
resource "aws_route53_record" "webapp_route53_SOA_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "SOA"
  ttl     = 900
  records = [var.SOA_record]
}

# NS record - will need to be imported
resource "aws_route53_record" "webapp_route53_NS_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "NS"
  ttl     = 172800
  records = split(", ", var.nameservers)
}

# A record pointing to LB
resource "aws_route53_record" "webapp_route53_cname_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = "www.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.loadbalancer_dns_name]
}