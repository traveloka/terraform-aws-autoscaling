module "asg" {
  source = "../../"

  service_name        = "paybe"
  environment         = "staging"
  product_domain      = "pay"
  description         = "Instances of paybe-app"
  application         = "java-8"
  associate_public_ip = "false"

  security_groups       = ["${aws_security_group.paybe-app.id}"]
  instance_profile_name = "${module.instance_profile.instance_profile_name}"

  image_owners = ["099720109477"]

  image_filters = [
    {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    },
    {
      name   = "virtualization-type"
      values = ["hvm"]
    },
  ]

  user_data = "${data.template_cloudinit_config.config.rendered}"

  asg_vpc_zone_identifier  = ["${data.aws_subnet_ids.app.ids}"]
  asg_lb_target_group_arns = []

  asg_wait_for_capacity_timeout = "1m"

  launch_template_overrides = [
    {
      "instance_type" = "t2.large"
    },
    {
      "instance_type" = "t3.large"
    },
  ]
}
