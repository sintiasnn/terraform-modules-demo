# ============================================================
# File: part2-terragrunt/production/terragrunt.hcl
# Tujuan: Konfigurasi spesifik untuk production
# Hanya nilai yang BERBEDA yang ditulis di sini. Sisanya diwarisi dari root.
# ============================================================

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment    = "production"
  instance_count = 5
  instance_type  = "t3.large"
}
