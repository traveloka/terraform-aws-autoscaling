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
- For on-demand instances, Auto Scaling will launch instances based on the order of preference specified in the `launch_template_overrides` list. [The default setting](variables.tf) specifies ["`c5.large`", "`c4.large`"] which means ASG will always try to launch `c5.large` if it's available, and `c4.large` otherwise
- On the first deployment, this module will provision an ASG with a launch template that select the most recent AMI that passes through the given `image_filters`
- Each time there's a change in the values of the `module.asg_name`'s keepers (e.g. security group, AMI ID), a new ASG will be provisioned by terraform, and the old one will later be destroyed (doing the "simple swap" deployment strategy).
- When there's a change in launch template parameters' values, terraform will create a new launch template version unless the new configuration is already the same as the latest version of the launch template (e.g. when the launch template had been updated externally).

## Authors
  - [Salvian Reynaldi](https://github.com/salvianreynaldi)

## License

See LICENSE for full details.
