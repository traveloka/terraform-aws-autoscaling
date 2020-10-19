# terraform-aws-autoscaling

[![Release](https://img.shields.io/github/release/traveloka/terraform-aws-autoscaling.svg)](https://github.com/traveloka/terraform-aws-autoscaling/releases)
[![Last Commit](https://img.shields.io/github/last-commit/traveloka/terraform-aws-autoscaling.svg)](https://github.com/traveloka/terraform-aws-autoscaling/commits/master)
![Open Source Love](https://badges.frapsoft.com/os/v1/open-source.png?v=103)

## Description

A terraform module which provisions an auto scaling group along with its launch configuration. 

## Prerequisites

## Dependencies

This Terraform module have no dependencies to another modules


## Getting Started

### Conventions
 - the auto scaling group will have `Service`, `Cluster`, `Environment`, and `ProductDomain` tags by default, which are propagated to all instances it spawns

### Behaviour
- To specify on-demand instance types, use the `launch_template_overrides` variable. Auto Scaling will launch instances based on the order of preference specified in that list. ["`c5.large`", "`c4.large`", "`m5.large`"] means the ASG will always try to launch `c5.large` if it's available, falling back to `c4.large` if it's not available, and falling back to `m5.large` if the previous two aren't available
- On the first deployment, this module will provision an ASG with a launch template that select the most recent AMI that passes through the given `image_filters`
- Each time there's a change in the values of the `module.asg_name`'s keepers (e.g. security group, AMI ID), a new ASG will be provisioned by terraform, and the old one will later be destroyed (doing the "simple swap" deployment strategy).
- When there's a change in launch template parameters' values, terraform will create a new launch template version unless the new configuration is already the same as the latest version of the launch template (e.g. when the launch template had been updated externally).

### Migration from pre-launch-template versions
```bash
terraform init
terraform state rm module.<this module name in your terraform code>.module.random_lc
terraform apply
```

### Switching between plain launch template and mixed instance policy
switching to plain launch template
```hcl
module "asg" {
  source = "github.com/traveloka/terraform-aws-autoscaling?ref=v0.3.1"
  # ...
  use_mixed_instance_policy = false
  launch_template_overrides = [
    {
      "instance_type" = "c4.large" # this (the first element) will be the launch template's instance type
    },
    {
      "instance_type" = "t3.medium"
    },
  ]
}

```

switching to mixed instance policy
```hcl
module "asg" {
  source = "github.com/traveloka/terraform-aws-autoscaling?ref=v0.3.1"
  # ...
  use_mixed_instance_policy = true
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| application | Application type that the ASG's instances will serve | `string` | n/a | yes |
| asg\_clb\_names | A list of classic load balancer names to add to the autoscaling group | `list(string)` | `[]` | no |
| asg\_default\_cooldown | Time, in seconds, the minimum interval of two scaling activities | `string` | `"300"` | no |
| asg\_enabled\_metrics | The list of ASG metrics to collect | `list(string)` | <pre>[<br>  "GroupMinSize",<br>  "GroupMaxSize",<br>  "GroupDesiredCapacity",<br>  "GroupInServiceInstances",<br>  "GroupPendingInstances",<br>  "GroupStandbyInstances",<br>  "GroupTerminatingInstances",<br>  "GroupTotalInstances"<br>]</pre> | no |
| asg\_health\_check\_grace\_period | Time, in seconds, to wait for new instances before checking their health | `string` | `"300"` | no |
| asg\_health\_check\_type | Controls how ASG health checking is done | `string` | `"ELB"` | no |
| asg\_lb\_target\_group\_arns | The created ASG will be attached to this target group | `list(string)` | `[]` | no |
| asg\_max\_capacity | The created ASG will have this number of instances at maximum | `string` | `"0"` | no |
| asg\_metrics\_granularity | The granularity to associate with the metrics to collect | `string` | `"1Minute"` | no |
| asg\_min\_capacity | The created ASG will have this number of instances at minimum | `string` | `"0"` | no |
| asg\_placement\_group | The placement group for the spawned instances | `string` | `""` | no |
| asg\_service\_linked\_role\_arn | The ARN of the service-linked role that the ASG will use to call other AWS services | `string` | `""` | no |
| asg\_tags | The created ASG will have these tags applied over the default ones (see main.tf) | `list(map(string))` | `[]` | no |
| asg\_termination\_policies | Specify policies that the auto scaling group should use to terminate its instances | `list(string)` | <pre>[<br>  "Default"<br>]</pre> | no |
| asg\_vpc\_zone\_identifier | The created ASG will spawn instances to these subnet IDs | `list(string)` | n/a | yes |
| asg\_wait\_for\_capacity\_timeout | A maximum duration that Terraform should wait for ASG instances to be healthy before timing out | `string` | n/a | yes |
| asg\_wait\_for\_elb\_capacity | Terraform will wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. If left to default, the value is set to asg\_min\_capacity | `string` | `""` | no |
| associate\_public\_ip | Whether to associate public IP to the instance | `string` | `"false"` | no |
| cluster\_role | Primary role/function of the cluster | `string` | `"app"` | no |
| cpu\_credits | The credit option for CPU usage, can be either 'standard' or 'unlimited' | `string` | `"unlimited"` | no |
| delete\_network\_interface\_on\_termination | Whether the network interface will be deleted on termination | `string` | `"true"` | no |
| delete\_on\_termination | Whether the volume should be destroyed on instance termination | `string` | `"true"` | no |
| description | Free form description of this ASG and its instances | `string` | n/a | yes |
| ebs\_encryption | Whether the volume will be encrypted or not | `string` | `"false"` | no |
| ebs\_optimized | The spawned instances will have EBS optimization if enabled | `string` | `"false"` | no |
| environment | The created resources will belong to this infrastructure environment | `string` | n/a | yes |
| image\_filters | The AMI search filters. The most recent AMI that pass this filter will be deployed to the ASG. See https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-images.html | <pre>list(object({<br>    name   = string,<br>    values = list(string)<br>    })<br>  )</pre> | n/a | yes |
| image\_owners | List of AMI owners to limit search. This becomes required starting terraform-provider-aws v2 (https://www.terraform.io/docs/providers/aws/guides/version-2-upgrade.html#owners-argument-now-required) | `list(string)` | n/a | yes |
| instance\_profile\_name | The spawned instances will have this IAM profile | `string` | n/a | yes |
| key\_name | The spawned instances will have this SSH key name | `string` | `""` | no |
| launch\_template\_overrides | List of nested arguments provides the ability to specify multiple instance types. See https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html#override<br>  When using plain launch template, the first element's instance\_type will be used as the launch template instance type. | `list(map(string))` | <pre>[<br>  {<br>    "instance_type": "c4.large"<br>  },<br>  {<br>    "instance_type": "t3.medium"<br>  }<br>]</pre> | no |
| mixed\_instances\_distribution | Specify the distribution of on-demand instances and spot instances. See https://docs.aws.amazon.com/autoscaling/ec2/APIReference/API_InstancesDistribution.html | `map(string)` | <pre>{<br>  "on_demand_allocation_strategy": "prioritized",<br>  "on_demand_base_capacity": "0",<br>  "on_demand_percentage_above_base_capacity": "100",<br>  "spot_allocation_strategy": "lowest-price",<br>  "spot_instance_pools": "2",<br>  "spot_max_price": ""<br>}</pre> | no |
| monitoring | The spawned instances will have enhanced monitoring if enabled | `string` | `"true"` | no |
| product\_domain | Abbreviation of the product domain this ASG and its instances belongs to | `string` | n/a | yes |
| security\_groups | The spawned instances will have these security groups | `list(string)` | n/a | yes |
| service\_name | The name of the service | `string` | n/a | yes |
| use\_mixed\_instances\_policy | Whether to use ASG mixed instances policy or the plain launch template | `bool` | `true` | no |
| user\_data | The spawned instances will have this user data. Use the rendered value of a terraform's `template_cloudinit_config` data | `string` | `" "` | no |
| volume\_size | The size of the volume in gigabytes | `string` | `"8"` | no |
| volume\_type | The type of volume. Can be standard, gp2, or io1 | `string` | `"gp2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| asg\_desired\_capacity | The desired capacity of the auto scaling group; it may be useful when doing blue/green asg deployment (create a new asg while copying the old's capacity) |
| asg\_name | The name of the auto scaling group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Contributing

This module accepting or open for any contributions from anyone, please see the [CONTRIBUTING.md](https://github.com/traveloka/terraform-aws-autoscaling/blob/master/CONTRIBUTING.md) for more detail about how to contribute to this module.

## License

This module is under Apache License 2.0 - see the [LICENSE](https://github.com/traveloka/terraform-aws-autoscaling/blob/master/LICENSE) file for details.