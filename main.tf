module "launch_template_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.19.1"

  name_prefix   = "${var.service_name}-${var.cluster_role}"
  resource_type = "launch_configuration"
}

module "asg_name" {
  source = "github.com/traveloka/terraform-aws-resource-naming.git?ref=v0.19.1"

  name_prefix   = "${var.service_name}-${var.cluster_role}"
  resource_type = "autoscaling_group"

  keepers = {
    image_id                  = data.aws_ami.latest_service_image.id
    instance_profile          = var.instance_profile_name
    key_name                  = var.key_name
    security_groups           = join(",", sort(var.security_groups))
    user_data                 = var.user_data
    monitoring                = var.monitoring
    ebs_optimized             = var.ebs_optimized
    ebs_volume_size           = var.volume_size
    ebs_volume_type           = var.volume_type
    ebs_delete_on_termination = var.delete_on_termination
  }
}

resource "aws_launch_template" "main" {
  name = module.launch_template_name.name

  image_id      = data.aws_ami.latest_service_image.id
  instance_type = var.use_mixed_instances_policy == true ? null : var.launch_template_overrides[0].instance_type
  iam_instance_profile {
    name = var.instance_profile_name
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  key_name  = var.key_name
  user_data = base64encode(var.user_data)

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip
    security_groups             = var.security_groups
    delete_on_termination       = var.delete_network_interface_on_termination
  }

  monitoring {
    enabled = var.monitoring
  }

  disable_api_termination = var.disable_api_termination
  ebs_optimized = var.ebs_optimized

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = var.volume_size
      volume_type           = var.volume_type
      delete_on_termination = var.delete_on_termination
      encrypted             = var.ebs_encryption
    }
  }

  tags = {
    Name          = module.launch_template_name.name
    Service       = var.service_name
    ProductDomain = var.product_domain
    Environment   = var.environment
    ManagedBy     = "terraform"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name          = "${var.service_name}-${var.cluster_role}"
      Service       = var.service_name
      Cluster       = "${var.service_name}-${var.cluster_role}"
      ProductDomain = var.product_domain
      Application   = var.application
      Environment   = var.environment
      Description   = var.description
      ManagedBy     = "terraform"
    }
  }
  tag_specifications {
    resource_type = "volume"

    tags = {
      Service       = var.service_name
      ProductDomain = var.product_domain
      Environment   = var.environment
      ManagedBy     = "terraform"
    }
  }
}

resource "aws_autoscaling_group" "main" {
  name_prefix               = module.asg_name.name
  max_size                  = var.asg_max_capacity
  min_size                  = var.asg_min_capacity
  default_cooldown          = var.asg_default_cooldown
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  vpc_zone_identifier       = var.asg_vpc_zone_identifier
  target_group_arns         = var.asg_lb_target_group_arns
  load_balancers            = var.asg_clb_names
  termination_policies      = var.asg_termination_policies


  dynamic "launch_template" {
    for_each = var.use_mixed_instances_policy == false ? ["use plain launch template"] : []
    content {
      id      = aws_launch_template.main.id
      version = "$Latest"
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_mixed_instances_policy == true ? ["use mixed instance policy"] : []
    content {
      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.main.id
          version            = "$Latest"
        }

        dynamic "override" {
          for_each = var.launch_template_overrides
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)
          }
        }
      }

      dynamic "instances_distribution" {
        for_each = [var.mixed_instances_distribution]
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }
    }
  }

  tags = concat(
    list(
      {
        key                 = "Name"
        value               = module.asg_name.name
        propagate_at_launch = false
      },
      {
        key                 = "Service"
        value               = var.service_name
        propagate_at_launch = false
      },
      {
        key                 = "ProductDomain"
        value               = var.product_domain
        propagate_at_launch = false
      },
      {
        key                 = "Environment"
        value               = var.environment
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
  }
}
