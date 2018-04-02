provider "aws" {
  region = "ap-southeast-1"
}

module "autoscaling-deployment" {
  source                  = "../.."
  tag_service_name        = "fprbe"
  tag_environment         = "staging"
  tag_product_domain      = "fprbe"
  asg_min_capacity        = 2
  asg_vpc_zone_identifier = []

  asg_tags = [
    {
      key                 = "AmiId"
      value               = "ami-9893cee4"
      propagate_at_launch = true
    },
    {
      key                 = "ServiceVersion"
      value               = "0.1.0"
      propagate_at_launch = true
    },
  ]

  asg_health_check_grace_period = 30
  asg_health_check_type         = "EC2"
  asg_wait_timeout              = "4m"
  lc_sgs                        = []
  lc_profile                    = ""
  lc_type                       = "t2.medium"
  lc_ami_id                     = "ami-9893cee4"
}
