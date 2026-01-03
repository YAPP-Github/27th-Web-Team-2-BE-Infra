variable "environment" { type = string }

variable "enable" {
  description = "sandbox 환경 리소스 생성 여부 제어용"
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "EC2 instance type for ECS EC2"
  type        = string
  default     = "t3.micro"
}

variable "ssh_ingress_cidrs" {
  type = list(string)
}

variable "app_ingress_cidrs" {
  type = list(string)
}

variable "container_image_tag" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}