# terraform-aws-autoscaling
A terraform module which provisions an auto scaling group along with its launch configuration

## Conventions
 - the auto scaling group will have `Service`, `Cluster`, `Environment`, and `ProductDomain` tags by default, which are propagated to all instances it spawns

## Behaviour
- Every time a new AMI is supplied (including first deployment), a new ASG will be created. If the deployment succeed, the old ASG will be destroyed.
If the deployment failed because the ASG status is unhealthy, both the new and the old ASG will remain; if this new ASG is attached to an ALB target group, the its instances should not receive traffic (as they are unhealthy). Subsequent failing deployments will add more unhealthy ASGs, and no ASG will be destroyed, but terraform will state these ASGs as deposed. When a new healthy ASG is deployed, all old ASGs (the last healthy one and the subsequent unhealthy ones) will then be destroyed.

## Authors
  - [Salvian Reynaldi](https://github.com/salvianreynaldi)

## License

See LICENSE for full details.
