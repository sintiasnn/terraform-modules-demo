# ============================================================
# File: part2-terragrunt/staging/main.tf
# Tujuan: Terraform code minimal — Terragrunt yang handle sisanya
# common_tags otomatis mengalir dari root terragrunt.hcl
# ============================================================

variable "environment" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

resource "aws_security_group" "this" {
  name        = "${var.environment}-sg"
  description = "Security group untuk ${var.environment}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "app" {
  source = "../../modules/ec2"

  instance_count = var.instance_count
  instance_type  = var.instance_type
  environment    = var.environment
  sg_ids         = [aws_security_group.this.id]
  extra_tags     = var.common_tags
}

output "instance_ids" {
  value = module.app.instance_ids
}
