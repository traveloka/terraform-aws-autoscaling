variable "service_name" {
  type        = "string"
  description = "The name of the service"
}

variable "cluster_role" {
  type        = "string"
  default     = "app"
  description = "Primary role/function of the cluster"
}

variable "environment" {
  type        = "string"
  description = "The created resources will belong to this infrastructure environment"
}

variable "application" {
  type        = "string"
  description = "Application type that the ASG's instances will serve"
}

variable "product_domain" {
  type        = "string"
  description = "Abbreviation of the product domain this ASG and its instances belongs to"
}

variable "description" {
  type        = "string"
  description = "Free form description of this ASG and its instances"
}

variable "asg_vpc_zone_identifier" {
  type        = "list"
  description = "The created ASG will spawn instances to these subnet IDs"
}

variable "asg_lb_target_group_arns" {
  type        = "list"
  default     = []
  description = "The created ASG will be attached to this target group"
}

variable "asg_min_capacity" {
  type        = "string"
  default     = 0
  description = "The created ASG will have this number of instances at minimum"
}

variable "asg_max_capacity" {
  type        = "string"
  default     = 0
  description = "The created ASG will have this number of instances at maximum"
}

variable "asg_health_check_type" {
  type        = "string"
  default     = "ELB"
  description = "Controls how ASG health checking is done"
}

variable "asg_health_check_grace_period" {
  type        = "string"
  default     = "300"
  description = "Time, in seconds, to wait for new instances before checking their health"
}

variable "asg_default_cooldown" {
  type        = "string"
  default     = "300"
  description = "Time, in seconds, the minimum interval of two scaling activities"
}

variable "asg_placement_group" {
  type        = "string"
  default     = ""
  description = "The placement group for the spawned instances"
}

variable "asg_metrics_granularity" {
  type        = "string"
  default     = "1Minute"
  description = "The granularity to associate with the metrics to collect"
}

variable "asg_enabled_metrics" {
  type = "list"

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  description = "The list of ASG metrics to collect"
}

variable "asg_service_linked_role_arn" {
  type        = "string"
  default     = ""
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
}

variable "asg_termination_policies" {
  type = "list"

  default = [
    "Default",
  ]

  description = "Specify policies that the auto scaling group should use to terminate its instances"
}

variable "asg_tags" {
  type        = "list"
  default     = []
  description = "The created ASG will have these tags applied over the default ones (see main.tf)"
}

variable "asg_wait_for_capacity_timeout" {
  type        = "string"
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
}

variable "asg_wait_for_elb_capacity" {
  type        = "string"
  default     = ""
  description = "Terraform will wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. If left to default, the value is set to asg_min_capacity"
}

variable "launch_template_overrides" {
  type = "list"

  default = [
    {
      "instance_type" = "c5.large"
    },
    {
      "instance_type" = "c4.large"
    },
  ]

  description = "List of nested arguments provides the ability to specify multiple instance types. See https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#override"
}

variable "security_groups" {
  type        = "list"
  description = "The spawned instances will have these security groups"
}

variable "instance_profile" {
  type        = "string"
  description = "The spawned instances will have this IAM profile"
}

variable "key_name" {
  type        = "string"
  default     = ""
  description = "The spawned instances will have this SSH key name"
}

variable "image_filters" {
  type        = "list"
  description = "The AMI search filters. The most recent AMI that pass this filter will be deployed to the ASG"
}

variable "image_owners" {
  type        = "list"
  description = "List of AMI owners to limit search. This becomes required starting terraform-provider-aws v2 (https://www.terraform.io/docs/providers/aws/guides/version-2-upgrade.html#owners-argument-now-required)"
}

variable "monitoring" {
  type        = "string"
  default     = "true"
  description = "The spawned instances will have enhanced monitoring if enabled"
}

variable "ebs_optimized" {
  type        = "string"
  default     = "false"
  description = "The spawned instances will have EBS optimization if enabled"
}

variable "user_data" {
  type        = "string"
  default     = " "
  description = "The spawned instances will have this user data. Use the rendered value of a terraform's `template_cloudinit_config` data" // https://www.terraform.io/docs/providers/template/d/cloudinit_config.html#rendered
}

variable "volume_size" {
  description = "The size of the volume in gigabytes"
  type        = "string"
  default     = "8"
}

variable "volume_type" {
  description = "The type of volume. Can be standard, gp2, or io1"
  type        = "string"
  default     = "gp2"
}

variable "delete_on_termination" {
  description = "Whether the volume should be destroyed on instance termination"
  default     = "true"
}

variable "mixed_instances_distribution" {
  type        = "map"
  description = ""

  default = {
    on_demand_allocation_strategy            = "prioritized"
    on_demand_base_capacity                  = "0"
    on_demand_percentage_above_base_capacity = "100"
    spot_allocation_strategy                 = "lowest-price"
    spot_instance_pools                      = "2"
    spot_max_price                           = ""
  }
}
