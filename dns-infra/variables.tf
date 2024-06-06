# LB name populated on deploy
variable "loadbalancer_dns_name" {
  type    = string
  default = "google.com"
}

# domain name
variable "domain" {
  default = "lev-the-dev.co.uk"
  type    = string
}

variable "nameservers" {
  type    = string
}

variable "SOA_record" {
  type    = string
}
