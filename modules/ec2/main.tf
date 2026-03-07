# ============================================================
# File: modules/ec2/main.tf
# Tujuan: Resource utama untuk membuat EC2 instance
# Menggunakan count untuk membuat multiple instances
# ============================================================

resource "aws_instance" "this" {
  count = var.instance_count

  ami           = var.ami
  instance_type = var.instance_type

  # Attach security group dari variabel
  vpc_security_group_ids = var.sg_ids

  # merge() menggabungkan tag lokal + common_tags dari Terragrunt
  tags = merge(
    {
      Name        = "${var.environment}-server-${count.index + 1}"
      Environment = var.environment
    },
    var.extra_tags
  )
}
