output "repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.app_repository.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.app_repository.name
}