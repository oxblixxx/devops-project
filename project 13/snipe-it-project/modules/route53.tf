# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone

# resource "aws_route53_zone" "oxtech-lava" {
#   name = "oxtech.lava"
# }

# resource "aws_route53_record" "oxtech-lava" {
#   for_each = {
#     for dvo in aws_acm_certificate.oyindamola.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   zone_id         = aws_route53_zone.oxtech-lava.zone_id
#}