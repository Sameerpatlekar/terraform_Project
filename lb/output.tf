output "load_balancer_dns" {
    value = aws_lb.app_lb.dns_name
}

output "target_group_arn" {
    value = aws_lb_target_group.app_tg.arn
}