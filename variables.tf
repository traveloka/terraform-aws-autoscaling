# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
  description = "the created ASGs will spawn instances to these subnet IDs"
}

variable "asg_lb_target_group_arn" {
  type        = "string"
  description = "the created ASGs will be attached to this target group"
}

variable "asg_min_capacity" {
  default     = 1
  description = "the created ASGs will have this number of instances at minimum"
}

variable "asg_desired_capacity" {
  type        = "string"
  description = "the created ASGs will be spawned initially with this capacity"
}

variable "asg_max_capacity" {
  default     = 5
  description = "the created ASGs will have this number of instances at maximum"
}

variable "asg_wait_timeout" {
  type        = "string"
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out"
}

variable "asg_health_check_type" {
  type        = "string"
  default     = "ELB"
  description = "controls how ASG health checking is done"
}

variable "asg_health_check_grace_period" {
  type        = "string"
  default     = "300"
  description = "Time, in seconds, to wait for new instances before checking their health"
}

variable "asg_service_linked_role_arn" {
  default     = ""
  description = "The ARN of the service-linked role that the ASG will use to call other AWS services"
}

variable "asg_termination_policies" {
  default = [
    "OldestLaunchConfiguration",
    "Default",
  ]

  description = "Specify policies that the auto scaling group should use to terminate its instances"
}

variable "asg_tags" {
  default     = []
  description = "the created ASGs will have these tags"
}

variable "lc_instance_sgs" {
  type        = "list"
  description = "the created instances will spawn instances with these security groups"
}

variable "lc_instance_profile" {
  type        = "string"
  description = "the created instances will spawn instances with this IAM profile"
}

variable "lc_instance_key_name" {
  default     = ""
  description = "the created instances will spawn instances with this SSH key name"
}

variable "lc_instance_type" {
  type        = "string"
  description = "the created instances will spawn instances with this type"
}

variable "lc_instance_ami_id" {
  type        = "string"
  description = "the created instances will spawn instances with this AMI"
}

variable "lc_instance_monitoring" {
  default     = true
  description = "the created instances will spawn instances with enhanced monitoring if enabled"
}

variable "lc_instance_ebs_optimized" {
  default     = true
  description = "the created instances will spawn EBS optimized instances if enabled"
}

variable "lc_instance_user_data" {
  default     = ""
  description = "The user data to launch instances with. Use the value of data.template_cloudinit_config.rendered" // https://www.terraform.io/docs/providers/template/d/cloudinit_config.html#rendered
}
