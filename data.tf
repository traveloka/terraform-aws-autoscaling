data "aws_ami" "latest_service_image" {
  owners           = ["${var.image_owners}"]
  most_recent      = true

  filter = [
    "${var.image_filters}",
  ]
}
