resource "aws_security_group" "paybe-app" {
  name        = "paybe-app"
  description = "paybe-app security group"
  vpc_id      = "${data.aws_vpc.staging.id}"

  tags = {
    Name          = "paybe-app"
    Service       = "paybe"
    ProductDomain = "pay"
    Environment   = "staging"
    Description   = "Security group for paybe-app"
    ManagedBy     = "terraform"
  }
}

resource "aws_security_group_rule" "egress-paybe-app-to-0_0_0_0-80" {
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.paybe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress paybe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-paybe-app-to-0_0_0_0-443" {
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.paybe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress paybe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-paybe-app-all-vpc" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  security_group_id = "${aws_security_group.paybe-app.id}"
  cidr_blocks       = ["${data.aws_vpc.staging.cidr_block}"]
}
