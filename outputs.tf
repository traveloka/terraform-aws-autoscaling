output "asg_desired_capacity" {
  value       = aws_autoscaling_group.main.desired_capacity
  description = "The desired capacity of the auto scaling group; it may be useful when doing blue/green asg deployment (create a new asg while copying the old's capacity)"
}

output "asg_name" {
  value       = aws_autoscaling_group.main.name
  description = "The name of the auto scaling group"
}

output "launch_template_name" {
  value       = aws_launch_template.main.name
  description = "The name of the launch template used by the auto scaling group"
}
