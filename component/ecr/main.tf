# Legacy ECS application image repository. Kept commented so it can be restored later.
# resource "aws_ecr_repository" "app_repository" {
#   name                 = "${var.environment}-app"
#   image_tag_mutability = "MUTABLE"
#
#   image_scanning_configuration {
#     scan_on_push = true
#   }
#
#   tags = {
#     Environment = var.environment
#     Service     = "app"
#   }
# }

resource "aws_ecr_repository" "lambda_repository" {
  name                 = "${var.environment}-app-lambda"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Service     = "app-lambda"
  }
}
