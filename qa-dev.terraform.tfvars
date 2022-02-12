environment = "qa-dev"
name        = "stuff"
region      = "ap-southeast-2"
cidr_block  = "10.97.0.0/16"
availability_zones = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
public_subnets = ["10.97.1.0/24", "10.97.2.0/24", "10.97.4.0/24"]
eks_nodes_private_subnets = ["10.97.24.0/23", "10.97.26.0/23", "10.97.28.0/23"]
database_private_subnets = ["10.97.60.0/24", "10.97.62.0/24", "10.97.64.0/24"]

backend_database_name = "stuff_dev_qa"
backend_instance_type = "db.r5.large"
allowed_cidr_blocks   = ["10.97.0.0/16"]
additional_tags       = { "Managed by" = "Terraform", "BusinessUnit" = "stuff", "CreatedBy" = "srijan", "Environment" = "qa-dev" }
backend_replica_count = 1
backend_root_password = "xxxxx"

release_version       = "1.20.10-20211013"
disk_size             = 80
k8s_version           = "1.20"
instance_types = ["t3.xlarge"]
scaling_config  = { "desired_size" = 3, "max_size" = 6, "min_size" = 3 }

