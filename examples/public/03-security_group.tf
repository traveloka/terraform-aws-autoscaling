resource "aws_security_group" "tpaybe-app" {
  name        = "tpaybe-app"
  description = "tpaybe-app security group"
  vpc_id      = "${data.aws_vpc.staging.id}"

  tags = {
    Name          = "tpaybe-app"
    Service       = "tpaybe"
    ProductDomain = "tpay"
    Environment   = "staging"
    Description   = "Security group for tpaybe-app"
    ManagedBy     = "terraform"
  }
}

resource "aws_security_group_rule" "egress-tpaybe-app-to-0_0_0_0-80" {
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.tpaybe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress tpaybe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-tpaybe-app-to-0_0_0_0-443" {
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.tpaybe-app.id}"
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "egress tpaybe-app to 0.0.0.0/0"
}

resource "aws_security_group_rule" "egress-tpaybe-app-all-vpc" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  security_group_id = "${aws_security_group.tpaybe-app.id}"
  cidr_blocks       = ["${data.aws_vpc.staging.cidr_block}"]
}
