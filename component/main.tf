module "sandbox" {
  count = var.environment == "sandbox" ? 1 : 0
  source = "./sandbox"
}

module "prod" {
  count = var.environment == "prod" ? 1 : 0
  source = "./prod"
}