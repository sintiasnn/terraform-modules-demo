# ============================================================
# File: modules/security-group/variables.tf
# Tujuan: Definisi input untuk modul security group
# ============================================================

variable "name" {
  description = "Nama security group"
  type        = string
}

variable "environment" {
  description = "Environment (staging/production/dll)"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}
