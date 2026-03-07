# ============================================================
# File: part2-terragrunt/staging/terragrunt.hcl
# Tujuan: Konfigurasi spesifik untuk staging
# Hanya nilai yang BERBEDA yang ditulis di sini. Sisanya diwarisi dari root.
# ============================================================

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  environment    = "staging"
  instance_count = 3
  instance_type  = "t3.micro"
}
