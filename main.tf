locals {
  # Set the wait_for_elb_capacity to asg_min_capacity if not explicitly provided
  asg_wait_for_elb_capacity = var.asg_wait_for_elb_capacity == "" ? var.asg_min_capacity : var.asg_wait_for_elb_capacity
}

module "random_lc" {
  source = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.19.0"

  name_prefix   = "${var.service_name}-${var.cluster_role}"
  resource_type = "launch_configuration"

  keepers = {
    lc_security_groups  = join(",", sort(var.lc_security_groups))
    lc_instance_profile = var.lc_instance_profile
    lc_key_name         = var.lc_key_name
    lc_instance_type    = var.lc_instance_type
    lc_ami_id           = var.lc_ami_id
    lc_monitoring       = var.lc_monitoring
    lc_ebs_optimized    = var.lc_ebs_optimized
    lc_user_data        = var.lc_user_data
  }
}

resource "aws_launch_configuration" "main" {
  name                 = module.random_lc.name
  image_id             = var.lc_ami_id
  instance_type        = var.lc_instance_type
  iam_instance_profile = var.lc_instance_profile
  key_name             = var.lc_key_name
  security_groups      = var.lc_security_groups
  user_data            = var.lc_user_data
  enable_monitoring    = var.lc_monitoring
  ebs_optimized        = var.lc_ebs_optimized

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.delete_on_termination
  }

  root_block_device = {
    volume_size           = "${var.volume_size}"
    volume_type           = "${var.volume_type}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = aws_launch_configuration.main.name
  max_size                  = var.asg_max_capacity
  min_size                  = var.asg_min_capacity
  default_cooldown          = var.asg_default_cooldown
  launch_configuration      = aws_launch_configuration.main.name
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = var.asg_vpc_zone_identifier
  target_group_arns         = var.asg_lb_target_group_arns
  termination_policies      = var.asg_termination_policies

  tags = concat(
   list( 
    {
      key                 = "Name"
      value               = aws_launch_configuration.main.name
      propagate_at_launch = true
    },
    {
      key                 = "Service"
      value               = var.service_name
      propagate_at_launch = true
    },
    {
      key                 = "Cluster"
      value               = "${var.service_name}-${var.cluster_role}"
      propagate_at_launch = true
    },
    {
      key                 = "Environment"
      value               = var.environment
      propagate_at_launch = true
    },
    {
      key                 = "ProductDomain"
      value               = var.product_domain
      propagate_at_launch = true
    },
    {
      key                 = "Application"
      value               = var.application
      propagate_at_launch = true
    },
    {
      key                 = "Description"
      value               = var.description
      propagate_at_launch = true
    },
    {
      key                 = "ManagedBy"
      value               = "terraform"
      propagate_at_launch = true
    }
   ),
   var.asg_tags
  )

  placement_group           = var.asg_placement_group
  metrics_granularity       = var.asg_metrics_granularity
  enabled_metrics           = var.asg_enabled_metrics
  wait_for_capacity_timeout = var.asg_wait_for_capacity_timeout
  wait_for_elb_capacity     = local.asg_wait_for_elb_capacity
  service_linked_role_arn   = var.asg_service_linked_role_arn

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      launch_configuration,
      max_size,
      min_size,
      health_check_grace_period,
      health_check_type,
    ]
  }
}

