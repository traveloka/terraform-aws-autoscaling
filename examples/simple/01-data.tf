data "aws_caller_identity" "current" {}

data "aws_vpc" "staging" {
  tags = {
    Name = "staging"
  }
}

data "aws_subnet_ids" "app" {
  vpc_id = "${data.aws_vpc.staging.id}"

  tags = {
    Tier = "app"
  }
}

data "template_file" "init" {
  template = "${file("${path.module}/templates/init.tpl")}"
}

data "template_cloudinit_config" "config" {
  gzip          = "true"
  base64_encode = "true"

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${data.template_file.init.rendered}"
  }
}
