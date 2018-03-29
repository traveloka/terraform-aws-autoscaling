variable "tag_service_name" {
  type        = "string"
  description = "the name of the service"
}

variable "tag_cluster_role" {
  default     = "app"
  description = "primary role/function of the cluster"
}

variable "tag_environment" {
  type        = "string"
  description = "the created resources will belong to this infrastructure environment"
}

variable "asg_vpc_zone_identifier" {
  type        = "list"
  description = "the created ASG will spawn instances to these subnet IDs"
}

variable "asg_lb_target_group_arns" {
  default     = []
  description = "the created ASG will be attached to this target group"
}

variable "asg_min_capacity" {
  default     = 1
  description = "the created ASG will have this number of instances at minimum"
}

variable "asg_max_capacity" {
  default     = 5
  description = "the created ASG will have this number of instances at maximum"
}

variable "asg_wait_timeout" {
  type        = "string"
  description = "a maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
}

variable "asg_health_check_type" {
  type        = "string"
  default     = "ELB"
  description = "controls how ASG health checking is done"
}

variable "asg_health_check_grace_period" {
  type        = "string"
  default     = 300
  description = "time, in seconds, to wait for new instances before checking their health"
}

variable "asg_default_cooldown" {
  default     = 300
  description = "time, in seconds, the minimum interval of two scaling activities"
}

variable "asg_placement_group" {
  default     = ""
  description = "the placement group for the spawned instances"
}

variable "asg_metrics_granularity" {
  default     = "1Minute"
  description = "the granularity to associate with the metrics to collect"
}

variable "asg_enabled_metrics" {
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

  description = "the list of ASG metrics to collect"
}

variable "asg_service_linked_role_arn" {
  default     = ""
  description = "the ARN of the service-linked role that the ASG will use to call other AWS services"
}

variable "asg_termination_policies" {
  default = [
    "Default",
  ]

  description = "Specify policies that the auto scaling group should use to terminate its instances"
}

variable "asg_tags" {
  default     = []
  description = "the created ASG will have these tags"
}

variable "lc_sgs" {
  type        = "list"
  description = "the spawned instances will have these security groups"
}

variable "lc_profile" {
  type        = "string"
  description = "the spawned instances will have this IAM profile"
}

variable "lc_key_name" {
  default     = ""
  description = "the spawned instances will have this SSH key name"
}

variable "lc_type" {
  type        = "string"
  description = "the spawned instances will have this type"
}

variable "lc_ami_id" {
  type        = "string"
  description = "the spawned instances will have this AMI"
}

variable "lc_monitoring" {
  default     = true
  description = "the spawned instances will have enhanced monitoring if enabled"
}

variable "lc_ebs_optimized" {
  default     = true
  description = "the spawned instances will have EBS optimization if enabled"
}

variable "lc_user_data" {
  default     = ""
  description = "the spawned instances will have this user data. Use the rendered value of a terraform's `template_cloudinit_config` data" // https://www.terraform.io/docs/providers/template/d/cloudinit_config.html#rendered
}
