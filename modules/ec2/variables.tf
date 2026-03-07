# ============================================================
# File: modules/ec2/variables.tf
# Tujuan: Definisi variabel untuk modul EC2
# Ini adalah "cetakan" yang bisa dipakai berulang kali
# ============================================================

variable "ami" {
  description = "ID AMI untuk EC2 instance (Amazon Linux 2 di ap-southeast-1)"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  description = "Tipe instance EC2 (contoh: t3.micro, t3.large)"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Jumlah instance yang akan dibuat"
  type        = number
  default     = 1
}

variable "environment" {
  description = "Nama environment (staging, production, dll) — WAJIB diisi!"
  type        = string
}

variable "sg_ids" {
  description = "List ID security group yang akan di-attach ke instance"
  type        = list(string)
}

variable "extra_tags" {
  description = "Tag tambahan yang akan digabungkan dengan tag default (untuk Terragrunt)"
  type        = map(string)
  default     = {}
}
