bucket         = "prod-tfstate-623271127404-ap-northeast-2-an"
key            = "terraform/prod/terraform.tfstate"
region         = "ap-northeast-2"

use_lockfile = true # DynamoDB 대신 S3 native lock
encrypt        = true

profile        = "prod-nomoney"   # aws configure --profile prod 에서 설정한 이름