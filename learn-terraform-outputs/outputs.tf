# Output declarations

output "vpc_id" {
  description = "id of vpc"
  value       = aws_vpc.vpc.id
}

output "lb_url" {
    description = "URL of load balancer"
    value       = aws_lb.lb.dns_name
}

output "web_server_count" {
    description = "number of web servers provisioned"
    value       = length(module.ec2_instances.instance_ids)
}