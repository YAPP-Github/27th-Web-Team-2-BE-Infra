module "sandbox" {
  count  = var.environment == "sandbox" ? 1 : 0
  source = "./sandbox"

  vpc_id             = aws_vpc.main.id
  public_subnet_ids  = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
}

module "prod" {
  count  = var.environment == "prod" ? 1 : 0
  source = "./prod"

  vpc_id             = aws_vpc.main.id
  public_subnet_ids  = [
    aws_subnet.public_a.id,
    aws_subnet.public_c.id
  ]
}