# Legacy ECS application image retention. Kept commented so it can be restored later.
# resource "aws_ecr_lifecycle_policy" "app_retention" {
#   repository = aws_ecr_repository.app_repository.name
#
#   policy = jsonencode({
#     rules = [
#       {
#         rulePriority = 1
#         description  = "Keep last 3 images"
#         selection = {
#           tagStatus   = "any"
#           countType   = "imageCountMoreThan"
#           countNumber = 3
#         }
#         action = {
#           type = "expire"
#         }
#       }
#     ]
#   })
# }

resource "aws_ecr_lifecycle_policy" "lambda_retention" {
  repository = aws_ecr_repository.lambda_repository.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 5 Lambda images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 5
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
