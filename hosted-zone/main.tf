variable "vpc_id" {}
variable "domain_name" {}
variable "vm_name" {}
variable "records" {}

resource "aws_route53_zone" "private" {
  name = var.domain_name
  vpc {
    vpc_id = var.vpc_id
  }
}

resource "aws_route53_record" "vm_record" {
  zone_id = aws_route53_zone.private.zone_id
  name    = var.vm_name
  type    = "A"
  ttl     = 300
  records = var.records
}

