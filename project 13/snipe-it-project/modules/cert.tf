
# Create the certificate using a wildcard for all the domains created in oyindamola.gq
resource "aws_acm_certificate" "oxtech" {
  domain_name       = "*.oxtech.lava"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route53_record.snipe-it]  // Assuming your Route 53 records are in this resource
}


resource "aws_acm_certificate_validation" "snipe-it" {
  certificate_arn         = aws_acm_certificate.oxtech.arn
  validation_record_fqdns = [
    for record in aws_route53_record.oxtech-lava : record.fqdn if record != null
  ]
}

# calling the hosted zone
#  data "aws_route53_zone" "oxtech" {
#    name         = "oxtech.lava"
#    private_zone = false
# }



# # create records for tooling
resource "aws_route53_record" "snipe-it" {
  zone_id = aws_route53_zone.oxtech.zone_id
  name    = "snipe-it.oxtech.lava"
  type    = "A"
  count = local.subnet_count
  alias {
    name                   = aws_lb.ext-alb[count.index].dns_name
    zone_id                = aws_lb.ext-alb[count.index].zone_id
    evaluate_target_health = true
  }
}





