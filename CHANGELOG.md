## v0.2.4 (Sep 01, 2020)

NOTES:
* Add .pre-commit-config.yaml to include terraform_fmt and terraform_docs
* Update README.md to be informative

## v0.2.3 (Aug 29, 2019)

NOTES:

* Remove `executable_users` option from aws_ami data source (#31)

## v0.2.2 (Jun 28, 2019)

NOTES:

* Set name_prefix instead of name for ASG, to prevent unintended removal of all ASGs during failed deployment (#17)

## v0.2.1 (Jun 21, 2019)

FEATURES:

* Add asg_clb_names variable to enable using Classic Load Balancer

## v0.2.0 (Jun 19, 2019)

FEATURES:

* Switch from launch configuration to launch template which enables:
    * mixing instance types
    * mixing on-demand and spot instances
    * burstable performance instance family's (t2/t3/t3a) unlimited burst
    * EC2 volumes tagging and launch template tag (previously only ASG and its instances)
    * This version is compatible with terraform version <=0.11.x

## v0.2.0-simple_swap (Jun 14, 2019)

FEATURES:

* Switch from launch configuration to launch template
* Enable mixing on demand and spot instances in the ASG
* Use simple swap deployment strategy (same as the previous master branch's strategy)
* Updated required terraform version to v0.12.0+

## v0.1.8-rolling (Oct 31, 2018)

NOTES:

* Update ManagedBy tag value to be `terraform` in lower case.

## v0.1.7-rolling (Oct 23, 2018)

FEATURES:

* Add ignore changes for these variables:
    * `max_size`
    * `min_size`
    * `health_check_grace_period`
    * `health_check_type`

BUG FIXES:

* Change default value for `user_data` variable to whitespace

## v0.1.6-rolling (Aug 15, 2018)

FEATURES:

* Add Root Block Storage definition
