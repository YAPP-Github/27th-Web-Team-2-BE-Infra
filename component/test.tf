resource "null_resource" "sandbox_plan_test" {
  triggers = {
    environment = var.environment
    timestamp   = timestamp()
  }
}