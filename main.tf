provider "aws" {
  region  = "ap-northeast-1"
  profile = "my-profile-name"
}

# バックアップ
terraform {
  backend "s3" {
    bucket = "terraform-deploy-bucket"
    key    = "terraform.tfstate"
    region = "ap-northeast-1"
    profile = "my-profile-name"
  }
}

# 変数の定義
variable "name" {
  description = "terraform"
  type        = "string"
  default     = "terraform"
}
