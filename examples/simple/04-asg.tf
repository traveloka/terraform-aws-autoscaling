module "asg" {
  source              = "../../"
  service_name        = "fprbe"
  environment         = "staging"
  product_domain      = "fpr"
  description         = "Instances of fprbe-app"
  application         = "java-8"
  associate_public_ip = "true"

  security_groups       = ["${aws_security_group.fprbe-app.id}"]
  instance_profile_name = "${module.instance_profile.instance_profile_name}"

  image_owners = ["${data.aws_caller_identity.current.account_id}"]

  image_filters = [
    {
      # See https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html for complete filter options
      name   = "name"
      values = ["tvlk/ubuntu-16/tsi/java-8*"]
    },
    {
      # If you want to directly specify the image ID
      name   = "image-id"
      values = ["ami-0ee74cd429a4a5143"]
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
