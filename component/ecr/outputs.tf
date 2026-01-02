output "repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.shared_app.repository_url
}

output "repository_name" {
  value = aws_ecr_repository.shared_app.name
}