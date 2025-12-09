##############################
# Terraform Backend Infra (S3 + DynamoDB)
##############################

# AWS Account ID를 불러오기 위한 데이터 소스
data "aws_caller_identity" "current" {}

##############################
# S3 Bucket for Terraform State
##############################

resource "aws_s3_bucket" "tfstate" {
  # 예: sandbox-tfstate-264015108625
  bucket = format(
    "%s-tfstate-%s",
    var.environment,
    data.aws_caller_identity.current.account_id
  )

  tags = {
    Name        = format("%s-tfstate", var.environment)
    Environment = var.environment
  }
}

# Versioning 활성화
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# 기본 SSE 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_encryption" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 퍼블릭 접근 차단
resource "aws_s3_bucket_public_access_block" "tfstate_public_access" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############################
# DynamoDB Table for State Lock
##############################

resource "aws_dynamodb_table" "tf_lock" {
  # 예: sandbox-tf-lock
  name         = format("%s-tf-lock", var.environment)
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = format("%s-tf-lock", var.environment)
    Environment = var.environment
  }
}