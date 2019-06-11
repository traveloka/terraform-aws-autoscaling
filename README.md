# terraform-aws-autoscaling
A terraform module which provisions an auto scaling group along with its launch configuration

## Conventions
 - the auto scaling group will have `Service`, `Cluster`, `Environment`, and `ProductDomain` tags by default, which are propagated to all instances it spawns

## Behaviour
- On the first deployment, this module will provision an ASG with a launch template that select the most recent AMI that passes through the given `image_filters`
- No rolling / blue green updates will be done automatically. AMI deployment is assumed to be done externally
- When any launch template parameters' values are changed within the terraform code (e.g. a new image_filters is supplied), terraform will create a new launch template version, unless the new configuration is the same as the latest version of the launch template (e.g. if the launch template had been updated externally during deployment).

## Authors
  - [Salvian Reynaldi](https://github.com/salvianreynaldi)

## License

See LICENSE for full details.
