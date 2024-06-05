# LB name populated on deploy
variable "loadbalancer_dns_name" {
  type    = string
}

# domain name
variable "domain" {
  default = "lev-the-dev.co.uk"
  type    = string
}