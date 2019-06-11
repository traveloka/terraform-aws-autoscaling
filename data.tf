data "aws_ami" "latest_service_image" {
  executable_users = ["self"]
  most_recent      = true
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["${var.image_filter["name"]}"]
  }

  filter {
    name   = "Tag:Service"
    values = ["${var.service_name}"]
  }

  filter {
    name   = "Tag:ProductDomain"
    values = ["${var.product_domain}"]
  }

  filter {
    name   = "Tag:Status"
    values = ["${var.image_filter["tag_status"]}"]
  }
}
