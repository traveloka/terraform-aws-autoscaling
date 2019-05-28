locals {
  # Set the wait_for_elb_capacity to asg_min_capacity if not explicitly provided
  asg_wait_for_elb_capacity = "${var.asg_wait_for_elb_capacity == "" ? var.asg_min_capacity : var.asg_wait_for_elb_capacity}"
}

module "random_lc" {
  source = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.16.1"

  name_prefix   = "${var.service_name}-${var.cluster_role}"
  resource_type = "launch_configuration"
}

resource "aws_launch_template" "main" {
  name          = "${module.random_lc.name}"
  image_id      = "${var.lc_ami_id}"
  instance_type = "${var.lc_instance_type}"

  iam_instance_profile {
    name = "${var.lc_instance_profile}"

    // TODO switch to ARN, more specific
  }

  key_name               = "${var.lc_key_name}"
  vpc_security_group_ids = ["${var.lc_security_groups}"]
  user_data              = "${var.lc_user_data}"

  monitoring {
    enabled = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = "${var.volume_size}"
      volume_size           = "${var.volume_size}"
      volume_type           = "${var.volume_type}"
      delete_on_termination = "${var.delete_on_termination}"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${module.random_lc.name}"
  max_size                  = "${var.asg_max_capacity}"
  min_size                  = "${var.asg_min_capacity}"
  default_cooldown          = "${var.asg_default_cooldown}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"
  vpc_zone_identifier       = ["${var.asg_vpc_zone_identifier}"]
  target_group_arns         = ["${var.asg_lb_target_group_arns}"]
  termination_policies      = ["${var.asg_termination_policies}"]

  launch_template {
    id      = "${aws_launch_template.main.id}"
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${module.random_lc.name}"
      propagate_at_launch = true
    },
    {
      key                 = "Service"
      value               = "${var.service_name}"
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = "${var.service_name}-${var.cluster_role}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = true
    },
    {
      key                 = "ProductDomain"
      value               = "${var.product_domain}"
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = "${var.application}"
      propagate_at_launch = true
    },
    {
      key                 = "Description"
      value               = "${var.description}"
      propagate_at_launch = true
    },
    {
      key                 = "ManagedBy"
      value               = "terraform"
      propagate_at_launch = true
    },
  ]

  tags = [
    "${var.asg_tags}",
  ]

  placement_group           = "${var.asg_placement_group}"
  metrics_granularity       = "${var.asg_metrics_granularity}"
  enabled_metrics           = "${var.asg_enabled_metrics}"
  wait_for_capacity_timeout = "${var.asg_wait_for_capacity_timeout}"
  wait_for_elb_capacity     = "${local.asg_wait_for_elb_capacity}"
  service_linked_role_arn   = "${var.asg_service_linked_role_arn}"

  lifecycle {
    create_before_destroy = true
  }
}
