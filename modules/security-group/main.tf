# ============================================================
# File: modules/security-group/main.tf
# Tujuan: Resource security group yang reusable
# ============================================================

resource "aws_security_group" "this" {
  name        = "${var.environment}-${var.name}"
  description = "Security group untuk ${var.environment} environment"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.name}"
    Environment = var.environment
  }
}
