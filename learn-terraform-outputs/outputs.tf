# Output declarations

output "vpc_id" {
  description = "id of vpc"
  value       = aws_vpc.vpc.id
}

output "lb_url" {
    description = "URL of load balancer"
    value       = "http://${module.elb_http.this_elb_dns_name}/"
}

output "web_server_count" {
    description = "number of web servers provisioned"
    value       = length(module.ec2_instances.instance_ids)
}