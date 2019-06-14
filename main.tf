module "random_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.16.1"

  name_prefix   = "${var.service_name}-${var.cluster_role}"
  resource_type = "launch_configuration"
}

resource "aws_launch_template" "main" {
  name = "${module.random_name.name}"

  image_id = "${data.aws_ami.latest_service_image.id}"

  iam_instance_profile {
    name = "${var.instance_profile}"
  }

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups}"]
  user_data              = "${base64encode(var.user_data)}"

  monitoring {
    enabled = "${var.monitoring}"
  }

  ebs_optimized = "${var.ebs_optimized}"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = "${var.volume_size}"
      volume_type           = "${var.volume_type}"
      delete_on_termination = "${var.delete_on_termination}"
    }
  }

  tags = {
    Name          = "${module.random_name.name}"
    Service       = "${var.service_name}"
    ProductDomain = "${var.product_domain}"
    Environment   = "${var.environment}"
    ManagedBy     = "terraform"
  }

  tag_specifications = [
    {
      resource_type = "instance"

      tags = {
        Name          = "${var.service_name}-${var.cluster_role}"
        Service       = "${var.service_name}"
        Cluster       = "${var.service_name}-${var.cluster_role}"
        ProductDomain = "${var.product_domain}"
        Application   = "${var.application}"
        Environment   = "${var.environment}"
        Description   = "${var.description}"
        ManagedBy     = "terraform"
      }
    },
    {
      resource_type = "volume"

      tags = {
        Service       = "${var.service_name}"
        ProductDomain = "${var.product_domain}"
        Environment   = "${var.environment}"
        ManagedBy     = "terraform"
      }
    },
  ]
}

resource "aws_autoscaling_group" "main" {
  name                      = "${module.random_name.name}"
  max_size                  = "${var.asg_max_capacity}"
  min_size                  = "${var.asg_min_capacity}"
  default_cooldown          = "${var.asg_default_cooldown}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  health_check_type         = "${var.asg_health_check_type}"
  vpc_zone_identifier       = ["${var.asg_vpc_zone_identifier}"]
  target_group_arns         = ["${var.asg_lb_target_group_arns}"]
  termination_policies      = ["${var.asg_termination_policies}"]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = "${aws_launch_template.main.id}"
        version            = "$Latest"
      }

      override = [
        "${var.launch_template_overrides}",
      ]
    }

    instances_distribution = ["${var.mixed_instances_distribution}"]
  }

  tags = [
    {
      key                 = "Name"
      value               = "${module.random_name.name}"
      propagate_at_launch = false
    },
    {
      key                 = "Service"
      value               = "${var.service_name}"
      propagate_at_launch = false
    },
    {
      key                 = "ProductDomain"
      value               = "${var.product_domain}"
      propagate_at_launch = false
    },
    {
      key                 = "Environment"
      value               = "${var.environment}"
      propagate_at_launch = false
    },
    {
      key                 = "Description"
      value               = "ASG of the ${var.service_name}-${var.cluster_role} cluster"
      propagate_at_launch = false
    },
    {
      key                 = "ManagedBy"
      value               = "terraform"
      propagate_at_launch = false
    },
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
