data "aws_ami" "latest_service_image" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["${var.image_filter["name"]}"]
  }

  filter {
    name   = "tag:Service"
    values = ["${var.service_name}"]
  }

  filter {
    name   = "tag:ProductDomain"
    values = ["${var.product_domain}"]
  }

  filter {
    name   = "tag:Status"
    values = ["${var.image_filter["tag_status"]}"]
  }

  count = "${length(keys(var.image_filter)) == 0 ? 0 : 1}"
}
