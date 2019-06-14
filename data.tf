data "aws_ami" "latest_service_image" {
  executable_users = ["self"]
  owners           = var.image_owners
  most_recent      = true

  dynamic "filter" {
    for_each = var.image_filters
    content {
      name   = lookup(filter.value, "name", null)
      values = lookup(filter.value, "values", null)
    }
  }
}
