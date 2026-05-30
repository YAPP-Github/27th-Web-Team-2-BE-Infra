variable "environment" {
  type = string
}

# Legacy ALB inputs. Kept commented so ALB routing can be restored later.
# variable "alb_arn" {
#   type = string
# }
#
# variable "alb_dns_name" {
#   type = string
# }
#
# variable "alb_zone_id" {
#   type = string
# }
#
# variable "target_group_arn" {
#   type = string
# }

variable "enable_lambda_api" {
  type        = bool
  description = "API Gateway HTTP API + Lambda 운영 경로 생성 여부"
  default     = true
}

variable "route_primary_api_to_lambda" {
  type        = bool
  description = "api.* 도메인을 Lambda HTTP API로 라우팅할지 여부"
  default     = true
}

variable "lambda_image_uri" {
  type        = string
  description = "Lambda container image URI"
}

variable "lambda_memory_size" {
  type        = number
  description = "Lambda memory size in MB"
  default     = 2048
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda timeout in seconds"
  default     = 90
}

variable "lambda_alias_name" {
  type        = string
  description = "Lambda alias name used by API Gateway"
  default     = "live"
}

variable "lambda_provisioned_concurrency" {
  type        = number
  description = "Provisioned concurrency count for the Lambda API alias"
  default     = 0

  validation {
    condition     = var.lambda_provisioned_concurrency >= 0
    error_message = "lambda_provisioned_concurrency must be greater than or equal to 0."
  }
}

variable "lambda_keep_warm_enabled" {
  type        = bool
  description = "Whether to keep the Lambda API alias warm with EventBridge"
  default     = true
}

variable "lambda_keep_warm_schedule_expression" {
  type        = string
  description = "EventBridge schedule expression for Lambda API keep-warm invokes"
  default     = "rate(5 minutes)"
}

variable "lambda_architectures" {
  type        = list(string)
  description = "Lambda instruction set architecture"
  default     = ["x86_64"]
}

variable "lambda_container_port" {
  type        = number
  description = "Port exposed by the Lambda web application"
  default     = 8080
}
