bucket         = "sandbox-tfstate-264015108625" # 실제 생성된 버킷 이름
key            = "terraform/sandbox/terraform.tfstate"
region         = "ap-northeast-2"
dynamodb_table = "sandbox-tf-lock"
encrypt        = true

profile        = "sandbox-nomoney"   # aws configure --profile sandbox 에서 설정한 이름