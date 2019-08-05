module "instance_profile" {
  source = "github.com/traveloka/terraform-aws-iam-role.git//modules/instance?ref=v1.0.1"

  service_name   = "fprbe"
  cluster_role   = "app"
  product_domain = "fpr"
  environment    = "staging"
}
