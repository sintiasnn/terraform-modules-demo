# ============================================================
# File: part1-modules/production/main.tf
# Tujuan: Konfigurasi environment PRODUCTION
# Perhatikan hanya nilai variabelnya yang berbeda — modulnya sama!
# ============================================================

provider "aws" {
  region = "ap-southeast-1"
}

# Modul security group untuk production
module "security_group" {
  source = "../../modules/security-group"

  name        = "sg"
  environment = "production"
}

# Modul EC2 dengan konfigurasi production
module "app" {
  source = "../../modules/ec2"

  instance_count = 5
  instance_type  = "t3.large"
  environment    = "production"
  sg_ids         = [module.security_group.security_group_id]
}

# Output dari modul
output "instance_ids" {
  description = "ID semua instance production"
  value       = module.app.instance_ids
}
