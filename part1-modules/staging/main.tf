# ============================================================
# File: part1-modules/staging/main.tf
# Tujuan: Konfigurasi environment STAGING
# Perhatikan hanya nilai variabelnya yang berbeda — modulnya sama!
# ============================================================

provider "aws" {
  region = "ap-southeast-1"
}

# Modul security group untuk staging
module "security_group" {
  source = "../../modules/security-group"

  name        = "sg"
  environment = "staging"
}

# Modul EC2 dengan konfigurasi staging
module "app" {
  source = "../../modules/ec2"

  instance_count = 3
  instance_type  = "t3.micro"
  environment    = "staging"
  sg_ids         = [module.security_group.security_group_id]
}

# Output dari modul
output "instance_ids" {
  description = "ID semua instance staging"
  value       = module.app.instance_ids
}
