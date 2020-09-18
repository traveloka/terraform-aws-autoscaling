provider "aws" {
  region = "ap-southeast-1"
}

module "autoscaling-deployment" {
  source                  = "../.."
  service_name            = "fprbe"
  environment             = "staging"
  application             = "java-7"
  product_domain          = "fprbe"
  description             = "fprbe instances"
  asg_min_capacity        = 2
  asg_vpc_zone_identifier = ["subnet-8270c222"]

  asg_tags = concat(
   list(
    {
      key                 = "AmiId"
      value               = "ami-9893cee4"
      propagate_at_launch = true
    },
    {
      key                 = "ServiceVersion"
      value               = "0.1.0"
      propagate_at_launch = true
    }
   ),
  )

  asg_health_check_grace_period = 30
  asg_health_check_type         = "EC2"
  asg_wait_for_capacity_timeout = "4m"
  lc_security_groups            = []
  lc_instance_profile           = ""
  lc_instance_type              = "t2.medium"
  lc_ami_id                     = "ami-9893cee4"
}

