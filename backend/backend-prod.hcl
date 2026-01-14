bucket         = "prod-tfstate-618531912247" # 실제 생성된 버킷 이름
key            = "terraform/prod/terraform.tfstate"
region         = "ap-northeast-2"

use_lockfile = true # DynamoDB 대신 S3 native lock
encrypt        = true

profile        = "prod-nomoney"   # aws configure --profile prod 에서 설정한 이름