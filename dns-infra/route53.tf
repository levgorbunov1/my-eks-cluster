# hosted zone
resource "aws_route53_zone" "webapp_route53_zone" {
  name = var.domain
}

# SOA record
resource "aws_route53_record" "webapp_route53_SOA_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "SOA"
  ttl     = 900
  records = [var.SOA_record]
}

# NS record
resource "aws_route53_record" "webapp_route53_NS_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "NS"
  ttl     = 172800
  records = split(", ", var.nameservers)
}

# A record pointing to LB
resource "aws_route53_record" "webapp_route53_alias_record" {
  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = var.domain
  type    = "A"

  alias {
    name                   = var.loadbalancer_dns_name
    zone_id                = "ZHURV8PSTC4K8"
    evaluate_target_health = true
  }
}

# ACM SSL configuration
resource "aws_acm_certificate" "webapp_route53_alias_record" {
  domain_name       = aws_route53_record.webapp_route53_alias_record.fqdn
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  count = length(aws_acm_certificate.webapp_route53_alias_record.domain_validation_options)

  zone_id = aws_route53_zone.webapp_route53_zone.zone_id
  name    = aws_acm_certificate.webapp_route53_alias_record.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.webapp_route53_alias_record.domain_validation_options[count.index].resource_record_type
  ttl     = 60
  records = [
    aws_acm_certificate.webapp_route53_alias_record.domain_validation_options[count.index].resource_record_value
  ]
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.webapp_route53_alias_record.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}