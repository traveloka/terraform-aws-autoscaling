data "aws_ami" "latest_service_image" {
  owners      = var.image_owners
  most_recent = true

  dynamic "filter" {
    for_each = var.image_filters
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }
}
