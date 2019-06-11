# terraform-aws-autoscaling
A terraform module which provisions an auto scaling group along with its launch configuration

## Conventions
 - the auto scaling group will have `Service`, `Cluster`, `Environment`, and `ProductDomain` tags by default, which are propagated to all instances it spawns

## Behaviour
- When the launch template parameter values are changed in the terraform code (e.g. a new image_filters is supplied), terraform will create a new launch template version, unless the new configuration is already the same as the latest version of the launch template (e.g. if the launch template is updated externally).
- No rolling / blue green updates will be done automatically. It is assumed to be done externally

## Authors
  - [Salvian Reynaldi](https://github.com/salvianreynaldi)

## License

See LICENSE for full details.
