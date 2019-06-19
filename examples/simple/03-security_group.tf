resource "aws_security_group" "fprbe-app" {
  name        = "fprbe-app"
  description = "fprbe-app security group"
  vpc_id      = "${data.aws_vpc.staging.id}"

  tags = {
    Name          = "fprbe-app"
    Service       = "fprbe"
    ProductDomain = "fpr"
    Environment   = "staging"
    Description   = "Security group for fprbe-app"
    ManagedBy     = "terraform"
  }
}

resource "aws_security_group_rule" "egress-fprbe-app-to-0_0_0_0-80" {
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.fprbe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress fprbe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-fprbe-app-to-0_0_0_0-443" {
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.fprbe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress fprbe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-fprbe-app-all-vpc" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  security_group_id = "${aws_security_group.fprbe-app.id}"
  cidr_blocks       = ["${data.aws_vpc.staging.cidr_block}"]
}
