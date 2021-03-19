locals {
  # Set the wait_for_elb_capacity to asg_min_capacity if not explicitly provided
  asg_wait_for_elb_capacity = "${var.asg_wait_for_elb_capacity == "" ? var.asg_min_capacity : var.asg_wait_for_elb_capacity}"
  desired_capacity = "${var.asg_desired_capacity == "-1" ? var.asg_min_capacity : var.asg_desired_capacity}"
}
