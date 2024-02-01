
# Create the certificate using a wildcard for all the domains created in oyindamola.gq
resource "aws_acm_certificate" "oxtech" {
  domain_name       = "*.oxtech.lava"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "snipe-it" {
  certificate_arn         = aws_acm_certificate.oxtech.arn
  validation_record_fqdns = [for record in aws_route53_record.snipe-it : record.fqdn]
}


# calling the hosted zone
 data "aws_route53_zone" "oxtech" {
   name         = "oxtech.lava"
   private_zone = false
}



# # create records for tooling
resource "aws_route53_record" "snipe-it" {
  zone_id = aws_route53_zone.oxtech.zone_id
  name    = "snipe-it.oxtech.lava"
  type    = "A"

  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}





