resource "aws_cloudwatch_log_group" "nomoney_transaction_log" {
  name              = format("/%s/nomoney/server/transaction_log", var.environment)
  retention_in_days = 14 # 로그 보존 기간 (필요에 따라 변경 가능)

  tags = {
    Environment = var.environment
  }
}

resource "aws_cloudwatch_log_group" "nomoney_console_log" {
  name              = format("/%s/nomoney/server/console_log", var.environment)
  retention_in_days = 14 # 로그 보존 기간 (필요에 따라 변경 가능)

  tags = {
    Environment = var.environment
  }
}
