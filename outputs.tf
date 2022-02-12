output "vpc_id" {
  value = module.vpc_resource.id
}

output "node_private_subnet_ids" {
  value       = module.node_private_subnets.private_subnet_ids
  description = "A list of the node private subnet ids"
}

output "rds_private_subnet_ids" {
  value       = module.rds_private_subnets.private_subnet_ids
  description = "A list of the rds private subnet ids"
}
