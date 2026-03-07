# ============================================================
# File: modules/security-group/outputs.tf
# Tujuan: Output yang dikembalikan ke caller
# ============================================================

output "security_group_id" {
  description = "ID dari security group yang dibuat"
  value       = aws_security_group.this.id
}

output "security_group_name" {
  description = "Nama dari security group yang dibuat"
  value       = aws_security_group.this.name
}
