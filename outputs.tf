output "asg-desired-capacity" {
  value       = "${aws_autoscaling_group.main.desired_capacity}"
  description = "the desired capacity of the auto scaling group; it may be useful when doing blue/green asg deployment (create a new asg while copying the old's capacity)"
}

output "asg-name" {
  value = "${aws_autoscaling_group.main.name}"
  value = "the name of the auto scaling group"
}
