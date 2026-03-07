# ============================================================
# File: part2-terragrunt/terragrunt.hcl (ROOT CONFIG)
# Tujuan: Konfigurasi global untuk semua environment
# Ini adalah "senjata rahasia" Terragrunt!
# Definisikan sekali di sini → otomatis tersebar ke semua environment di bawahnya
# ============================================================

locals {
  project    = "terraform-modules-demo"
  managed_by = "Terragrunt"
  version    = "v1.0.0"
}

# Inject common_tags ke semua child modules
inputs = {
  common_tags = {
    Project    = local.project
    ManagedBy  = local.managed_by
    Version    = local.version
  }
}

# Auto-generate provider.tf di setiap child directory
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "ap-southeast-1"
}
EOF
}
