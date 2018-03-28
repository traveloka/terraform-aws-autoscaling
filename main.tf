# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "aws_launch_configuration" "main" {
  name_prefix          = "${var.tag_service_name}-${var.tag_cluster_role}-${var.tag_environment}-"
  image_id             = "${var.lc_instance_ami_id}"
  instance_type        = "${var.lc_instance_type}"
  iam_instance_profile = "${var.lc_instance_profile}"
  key_name             = "${var.lc_instance_key_name}"
  security_groups      = ["${var.lc_instance_sgs}"]
  user_data            = "${var.lc_instance_user_data}"
  enable_monitoring    = "${var.lc_instance_monitoring}"
  ebs_optimized        = "${var.lc_instance_ebs_optimized}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {
  name                      = "${aws_launch_configuration.main.name}"
  max_size                  = "${var.asg_max_capacity}"
  min_size                  = "${var.asg_min_capacity}"
  desired_capacity          = "${max(1, var.asg_desired_capacity)}"
  wait_for_elb_capacity     = "${max(1, var.asg_desired_capacity)}"
  wait_for_capacity_timeout = "${var.asg_wait_timeout}"
  health_check_type         = "${var.asg_health_check_type}"
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  vpc_zone_identifier       = "${var.asg_vpc_zone_identifier}"
  launch_configuration      = "${aws_launch_configuration.main.name}"
  target_group_arns         = ["${var.asg_lb_target_group_arn}"]
  service_linked_role_arn   = "${var.asg_service_linked_role_arn}"
  termination_policies      = ["${var.asg_termination_policies}"]

  tags = [
    "${var.asg_tags}",
  ]

  lifecycle {
    create_before_destroy = true
  }
}
