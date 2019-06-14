provider "aws" {
  region = "ap-southeast-1"
}

module "asg" {
  source = "../.."

  service_name   = "fprbe"
  environment    = "production"
  product_domain = "fpr"
  description    = "Instances of fprbe-app"
  application    = "java-8"

  security_groups  = []
  instance_profile = "myinstance-profile"

  image_owners = ["123456789012"]

  image_filters = [
    # See https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html for complete filter options
    {
      name   = "name"
      values = ["traveloka-fprbe-app-*"]
    },
    # If you want to directly specify the image ID
    {
      name   = "image-id"
      values = ["ami-91920591023019"]
    },
  ]

  instance_type = "m5.large"
  user_data     = "echo starting fprbe"
  key_name      = ""

  asg_vpc_zone_identifier  = ["subnet-a2b50c9d", "subnet-718c9efe"]
  asg_lb_target_group_arns = []

  asg_wait_for_capacity_timeout = "1m"
}
