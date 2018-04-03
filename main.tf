resource "random_id" "main" {
  keepers = {
    lc_sgs           = "${join(",",sort(var.lc_sgs))}"
    lc_profile       = "${var.lc_profile}"
    lc_key_name      = "${var.lc_key_name}"
    lc_type          = "${var.lc_type}"
    lc_ami_id        = "${var.lc_ami_id}"
    lc_monitoring    = "${var.lc_monitoring}"
    lc_ebs_optimized = "${var.lc_ebs_optimized}"
    lc_user_data     = "${var.lc_user_data}"
  }

  byte_length = 8
  prefix      = "${var.service_name}-${var.cluster_role}-${var.environment}-"
}

resource "aws_launch_configuration" "main" {
  name                 = "${random_id.main.b64_url}"
  image_id             = "${var.lc_ami_id}"
  instance_type        = "${var.lc_type}"
  iam_instance_profile = "${var.lc_profile}"
  key_name             = "${var.lc_key_name}"
  security_groups      = ["${var.lc_sgs}"]
  user_data            = "${var.lc_user_data}"
  enable_monitoring    = "${var.lc_monitoring}"
  ebs_optimized        = "${var.lc_ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${aws_launch_configuration.main.name}"
  max_size                  = "${var.asg_max_capacity}"
  min_size                  = "${var.asg_min_capacity}"
  default_cooldown          = "${var.asg_default_cooldown}"
  launch_configuration      = "${aws_launch_configuration.main.name}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"
  vpc_zone_identifier       = "${var.asg_vpc_zone_identifier}"
  target_group_arns         = ["${var.asg_lb_target_group_arns}"]
  termination_policies      = ["${var.asg_termination_policies}"]

  tags = [
    {
      key                 = "Name"
      value               = "${var.service_name}-${var.cluster_role}"
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
  ]

  tags = [
    "${var.asg_tags}",
  ]

  placement_group           = "${var.asg_placement_group}"
  metrics_granularity       = "${var.asg_metrics_granularity}"
  enabled_metrics           = "${var.asg_enabled_metrics}"
  wait_for_capacity_timeout = "${var.asg_wait_timeout}"
  wait_for_elb_capacity     = "${var.asg_min_capacity}"
  service_linked_role_arn   = "${var.asg_service_linked_role_arn}"

  lifecycle {
    create_before_destroy = true
  }
}
