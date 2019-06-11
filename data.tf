data "aws_ami" "latest_service_image" {
  executable_users = ["self"]
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
