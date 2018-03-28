module "autoscaling-deployment" {
  source                        = "../.."
  tag_service_name              = "flight"
  tag_environment               = "staging"
  asg_lb_target_group_arn       = "${aws_lb_target_group.backend.arn}"
  asg_health_check_type         = "EC2"
  asg_min_capacity              = 0
  asg_desired_capacity          = 0
  asg_vpc_zone_identifier       = []
  asg_health_check_grace_period = 30
  asg_wait_timeout              = "4m"

  lc_instance_sgs = []

  lc_instance_profile = ""
  lc_instance_type    = "t2.small"
  lc_instance_ami_id  = "ami-52d4802e"
}
