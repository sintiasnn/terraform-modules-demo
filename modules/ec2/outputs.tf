# ============================================================
# File: modules/ec2/outputs.tf
# Tujuan: Output values yang bisa diakses oleh caller
# ============================================================

output "instance_ids" {
  description = "List semua ID instance yang dibuat"
  value       = aws_instance.this[*].id
}

output "instance_public_ips" {
  description = "List semua public IP dari instance"
  value       = aws_instance.this[*].public_ip
}
