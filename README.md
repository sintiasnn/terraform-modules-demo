# Terraform Modules Demo

Repository ini adalah materi demo untuk presentasi teaching: **"Introducing Terraform Modules: Making Infrastructure As Code Easier"**

## 📚 Tentang Repo Ini

Repo ini dibuat untuk mengajarkan konsep Terraform Modules dan Terragrunt DRY pattern dengan cara yang mudah dipahami. Semua kode ditulis dengan komentar lengkap dalam Bahasa Indonesia agar lebih mudah diikuti.

**Tujuan pembelajaran:**
- Memahami cara membuat dan menggunakan Terraform modules
- Melihat bagaimana satu modul bisa dipakai untuk multiple environments
- Mengenal Terragrunt sebagai tool untuk mengurangi duplikasi kode
- Praktik langsung dengan contoh real-world (EC2 instances)

## 📁 Struktur Folder

```
terraform-modules-demo/
├── modules/
│   ├── ec2/                  # Modul reusable untuk EC2 instance
│   └── security-group/       # Modul reusable untuk Security Group
├── part1-modules/            # Demo Part 1: Local Modules
│   ├── staging/
│   └── production/
└── part2-terragrunt/         # Demo Bonus: Terragrunt DRY pattern
    ├── terragrunt.hcl        # Root config (common_tags di sini!)
    ├── staging/
    └── production/
```

**Part 1** fokus pada konsep dasar Terraform modules dengan 2 modul reusable.  
**Part 2** menunjukkan bagaimana Terragrunt membuat kode lebih DRY (Don't Repeat Yourself).

---

## 🎯 Part 1: Local Modules

### Cara Baca Alurnya

1. **Mulai dari `modules/ec2/`** — blueprint untuk EC2 instances
   - `variables.tf` → definisi input yang bisa dikustomisasi
   - `main.tf` → resource EC2 yang sebenarnya dibuat
   - `outputs.tf` → data yang dikembalikan ke caller

2. **Lanjut ke `modules/security-group/`** — blueprint untuk Security Group
   - `variables.tf` → definisi input (name, environment, ingress_rules)
   - `main.tf` → resource security group dengan dynamic ingress rules
   - `outputs.tf` → mengembalikan security_group_id

3. **Lihat `part1-modules/staging/`** — environment pertama
   - Memanggil 2 modul: security-group + ec2
   - Konfigurasi: 3 instance, t3.micro
   
4. **Bandingkan dengan `part1-modules/production/`** — environment kedua
   - Memanggil modul yang SAMA dengan konfigurasi berbeda
   - Konfigurasi: 5 instance, t3.large

### 💡 Aha Moment!

**Dua environment, dua modul reusable!**

Perhatikan bahwa `staging` dan `production` menggunakan modul yang sama persis, tapi dengan nilai variabel yang berbeda:

| Environment | instance_count | instance_type | security_group |
|-------------|----------------|---------------|----------------|
| Staging     | 3              | t3.micro      | staging-sg     |
| Production  | 5              | t3.large      | production-sg  |

Ini adalah kekuatan modules: **Write once, use everywhere!**

### 🚀 Cara Jalankan

```bash
# Masuk ke folder staging
cd part1-modules/staging

# Initialize Terraform (download provider, setup modules)
terraform init

# Lihat apa yang akan dibuat (dry-run)
terraform plan

# Untuk production, ulangi langkah yang sama
cd ../production
terraform init
terraform plan
```

**Catatan:** Jangan jalankan `terraform apply` kecuali kamu punya AWS credentials dan siap membuat resource sungguhan!

---

## 🎁 Part 2 Bonus: Terragrunt

### Masalah yang Dipecahkan

Di Part 1, kita sudah mengurangi duplikasi dengan modules. Tapi masih ada masalah:

❌ **Sebelum Terragrunt:**
- Provider config diulang di setiap environment
- Tags seperti `Project`, `ManagedBy`, `Version` harus ditulis manual di setiap tempat
- Kalau mau update version, harus edit banyak file

✅ **Dengan Terragrunt:**
- Provider config di-generate otomatis
- Common tags didefinisikan sekali di root, inject otomatis ke semua environment
- Update version di 1 baris → semua resource ter-update!

### Cara Kerja common_tags

1. **Definisi di `part2-terragrunt/terragrunt.hcl` (root):**
   ```hcl
   inputs = {
     common_tags = {
       Project    = "terraform-modules-demo"
       ManagedBy  = "Terragrunt"
       Version    = "v1.0.0"
     }
   }
   ```

2. **Otomatis tersedia di child configs:**
   - `staging/terragrunt.hcl` tidak perlu menulis ulang common_tags
   - `production/terragrunt.hcl` juga tidak perlu menulis ulang
   - Semua environment dapat common_tags secara otomatis!

3. **Dipakai di Terraform code:**
   ```hcl
   module "app" {
     extra_tags = var.common_tags  # Inject ke modul
   }
   ```

4. **Digabungkan di modul EC2:**
   ```hcl
   tags = merge(
     { Name = "...", Environment = "..." },
     var.extra_tags  # common_tags masuk di sini
   )
   ```

### 💡 Highlight: Update Version di 1 Baris

Coba ubah `version = "v1.0.0"` menjadi `version = "v2.0.0"` di `part2-terragrunt/terragrunt.hcl`.

Semua resource di staging DAN production akan otomatis punya tag `Version = "v2.0.0"` tanpa perlu edit file lain!

### 🚀 Cara Jalankan

```bash
# Masuk ke folder staging
cd part2-terragrunt/staging

# Initialize dengan Terragrunt
terragrunt init

# Lihat apa yang akan dibuat
terragrunt plan

# Untuk production, ulangi langkah yang sama
cd ../production
terragrunt init
terragrunt plan
```

**Perhatikan:** Terragrunt akan auto-generate file `provider.tf` di folder staging dan production.

---

### 🧪 Eksperimen Sendiri

Setelah memahami konsep dasarnya, coba eksperimen berikut:

### Eksperimen 1: Ubah Instance Count
```bash
cd part1-modules/staging
# Edit main.tf, ubah instance_count dari 3 menjadi 2
terraform plan
# Lihat bagaimana Terraform akan menghapus 1 instance
```

### Eksperimen 2: Kustomisasi Security Group Rules
```hcl
# Edit part1-modules/staging/main.tf
module "security_group" {
  source = "../../modules/security-group"
  
  name        = "sg"
  environment = "staging"
  
  # Tambahkan custom ingress rules
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]  # Hanya dari internal network
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # HTTPS dari mana saja
    }
  ]
}
```

### Eksperimen 3: Tambah Tag Baru di Terragrunt
```hcl
# Edit part2-terragrunt/terragrunt.hcl
inputs = {
  common_tags = {
    Project    = "terraform-modules-demo"
    ManagedBy  = "Terragrunt"
    Version    = "v1.0.0"
    Owner      = "Tim DevOps"  # Tag baru!
  }
}
```
Jalankan `terragrunt plan` di staging dan production — tag baru otomatis muncul di semua resource!

### Eksperimen 4: Tambah Environment Baru (UAT)
```bash
# Copy folder staging
cp -r part2-terragrunt/staging part2-terragrunt/uat

# Edit part2-terragrunt/uat/terragrunt.hcl
inputs = {
  environment    = "uat"
  instance_count = 2
  instance_type  = "t3.small"
}

# Jalankan
cd part2-terragrunt/uat
terragrunt init
terragrunt plan
```

---

## ⚠️ Catatan Penting

**Repo ini untuk DEMO dan PEMBELAJARAN saja!**

- ❌ Jangan di-apply ke AWS sungguhan tanpa memahami konsekuensinya
- ❌ Tidak ada backend configuration (state disimpan lokal)
- ❌ Security group rules menggunakan default 0.0.0.0/0 (tidak aman untuk production)
- ❌ Tidak ada error handling atau validation yang lengkap

Jika ingin menggunakan untuk production:
- Setup remote backend (S3 + DynamoDB)
- Perketat security group rules via `ingress_rules` variable
- Tambahkan validation dan error handling
- Gunakan AWS credentials dengan IAM role yang proper

---

## 📖 Referensi

- [Terraform Modules Documentation](https://developer.hashicorp.com/terraform/language/modules)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)
- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Selamat belajar! 🚀**

Jika ada pertanyaan atau menemukan bug, silakan buka issue atau diskusikan dengan instruktur.
