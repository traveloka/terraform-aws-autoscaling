data "aws_ami" "latest_service_image" {
  executable_users = ["self"]
  owners           = ["${var.image_owners}"]
  most_recent      = true

  filter = [
    {
      name   = "tag:Service"
      values = ["${var.service_name}"]
    },
    {
      name   = "tag:ProductDomain"
      values = ["${var.product_domain}"]
    },
    "${var.image_filters}",
  ]
}
