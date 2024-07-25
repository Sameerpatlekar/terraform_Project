output "rds_endpoint" {
  value = join("", slice(split(":", aws_db_instance.rds.endpoint), 0, 1))
  depends_on = [aws_db_instance.rds]
}
