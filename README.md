# terraform-aws-autoscaling
A terraform module which provisions an auto scaling group along with its launch configuration

## Conventions
 - the auto scaling group will have `Service`, `Cluster`, `Environment`, and `ProductDomain` tags by default, which are propagated to all instances it spawns

## Migration from pre-launch-template versions
```bash
terraform init
terraform state rm module.<this module name in your terraform code>.module.random_lc
terraform apply
```


## Behaviour
- On the first deployment, this module will provision an ASG with a launch template that select the most recent AMI that passes through the given `image_filters`
- Each time there's a change in the values of the `module.asg_name`'s keepers (e.g. security group, AMI ID), a new ASG will be provisioned by terraform, and the old one will later be destroyed (doing the "simple swap" deployment strategy).
- When any launch template parameters' values are changed within the terraform code (e.g. a new image_filters is supplied), terraform will create a new launch template version, unless the new configuration is the same as the latest version of the launch template (e.g. when the launch template had been updated externally).

## Authors
  - [Salvian Reynaldi](https://github.com/salvianreynaldi)

## License

See LICENSE for full details.
