########### VPC ###############

module "vpc_resource" {
  source     = "./module/terraform-aws-vpc"
  create_vpc = var.create_vpc
  cidr_block = var.cidr_block
  name       = local.name
  enable_dns_hostnames = true
  tags       = local.vpc_tags
}

########### Public subnet ###############

module "public_subnet" {
  source               = "./module/terraform-aws-public_subnets"
  name                 = local.name
  vpc_id               = module.vpc_resource.id
  availability_zones   = var.availability_zones
  public_subnets       = var.public_subnets
  public_subnet_suffix = "public"
  tags                 = local.public_subnet_tags
}

########### Node Private subnet ###############

module "node_private_subnets" {
  source             = "./module/terraform-aws-private_subnets"
  name               = local.name
  vpc_id             = module.vpc_resource.id
  create_nat         = true
  availability_zones = var.availability_zones
  private_subnets    = var.eks_nodes_private_subnets
  public_subnets_ids = module.public_subnet.public_subnet_ids
  tier               = "nodes"
  tags               = local.private_subnet_tags
}

########### DB Private subnet ###############

module "rds_private_subnets" {
  source             = "./module/terraform-aws-private_subnets"
  name               = local.name
  vpc_id             = module.vpc_resource.id
  create_nat         = false
  availability_zones = var.availability_zones
  private_subnets    = var.database_private_subnets
  nat_gateway_ids    = module.node_private_subnets.nat_gateway_ids
  tier               = "db"
  tags               = local.private_subnet_tags
}

############# RDS Database ###################

module "backend-rds" {
  source  = "./module/terraform-aws-rds-aurora"

  create_cluster = var.backend_create_cluster
  family         = "aurora-mysql5.7"
  subnets        = module.rds_private_subnets.private_subnet_ids
  vpc_id         = module.vpc_resource.id

  parameters = [{
    name         = "binlog_format"
    value        = "MIXED"
    apply_method = "pending-reboot"
  }]

  name              = local.name
  identifier        = "backend-db"
  engine            = "aurora-mysql"
  engine_version    = "5.7.mysql_aurora.2.10.1"
  instance_type     = var.backend_instance_type
  storage_encrypted = true

  publicly_accessible = false
  allowed_cidr_blocks = var.allowed_cidr_blocks

  replica_count           = var.backend_replica_count
  replica_scale_enabled   = var.backend_replica_scale_enabled
  backup_retention_period = var.backend_backup_retention_period
  backtrack_window        = var.backend_backtrack_window

  iam_database_authentication_enabled = true

  database_name = var.backend_database_name
  password      = var.backend_root_password

  apply_immediately   = true
  monitoring_interval = 0

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  additional_tags                 = var.additional_tags
}

module "eks" {
  source                  = "./module/terraform-aws-eks"
  create_eks              = true
  name                    = local.name
  k8s_version             = var.k8s_version
  endpoint_private_access = true
  endpoint_public_access  = false
  ### This is added for Terraform cloud can access EKS to deploy ingress and other helm charts
  #public_access_cidrs = var.public_access_cidrs
  subnet_ids = module.node_private_subnets.private_subnet_ids
  vpc_id     = module.vpc_resource.id

  create_elb_service_linked_role = var.create_elb_service_linked_role

  cluster_log_retention_in_days = 30

  allowed_cidrs = ["10.97.0.0/16"]
  tags = merge(
    var.additional_tags,
    {
      "kubernetes.io/cluster/${local.name}" = "owned"
    },
    {
      "Environment" = format("%s", var.environment)
    }
  )
}

module "eks-node-group-on-demand" {
  source  = "./module/terraform-aws-eks-node-group"

  name            = local.name
  cluster_name    = module.eks.eks_id
  node_group_name = "${local.name}-on-demand"

  node_role_arn   = module.eks.nodes_role_arn[0]
  ami_type        = "AL2_x86_64"
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  release_version = var.release_version

  remote_access = var.remote_access
  k8s_version   = var.k8s_version

  subnet_ids = module.node_private_subnets.private_subnet_ids
  vpc_id     = module.vpc_resource.id

  scaling_config = var.scaling_config

  labels = {
    "environment" = var.environment,
    "node_group"  = "${local.name}-on-demand",
  }
}
