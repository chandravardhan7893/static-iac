variable "region" {
  type        = string
  description = ""
  default     = "ap-southeast-2"
}

############ VPC Details #############
variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = "example"
}

variable "cidr_block" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "10.97.0.0/16"
}

variable "environment" {
  type        = string
  description = "Environment in tags to identidy"
  default     = "qa-dev"
}

variable "additional_tags" {
  type        = map(string)
  description = "Tags that you want to add to all resources"
  default     = {}
}

######## Public Subnets #####
variable "availability_zones" {
  description = "A list of availability_zones  inside the Region"
  type        = list(string)
  default     = null
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.97.1.0/24", "10.97.2.0/24", "10.97.4.0/24"]
}

######### Node Subnets #############

variable "eks_nodes_private_subnets" {
  description = "A list of private subnets inside the VPC for EKS nodes"
  type        = list(string)
  default     = ["10.97.24.0/23", "10.97.26.0/23", "10.97.28.0/23"]
}

##### Database subnets ##############

variable "database_private_subnets" {
  description = "A list of private subnets inside the VPC for RDS"
  type        = list(string)
  default     = ["10.97.60.0/24", "10.97.62.0/24", "10.97.64.0/24"]
}

############### RDS Database ################

variable "backend_create_cluster" {
  type        = bool
  description = "Do you want to create RDS Cluster"
  default     = true
}

variable "backend_instance_type" {
  description = "Instance type to use"
  type        = string
}

variable "backend_replica_count" {
  description = "Number of reader nodes to create.  If `replica_scale_enable` is `true`, the value of `replica_scale_min` is used instead."
  default     = 2
}

variable "backend_replica_scale_enabled" {
  description = "Whether to enable autoscaling for RDS Aurora (MySQL) read replicas"
  type        = bool
  default     = false
}

variable "backend_backup_retention_period" {
  description = "How long to keep backups for (in days)"
  type        = number
  default     = 1
}

variable "backend_backtrack_window" {
  description = <<EOT
                 The target backtrack window, in seconds.Only available for aurora engine currently. 
                 To disable backtracking, set this value to 0. Defaults to 0. 
                 Must be between 0 and 259200 (72 hours)"
                EOT
  type        = number
  default     = 0
}

variable "backend_database_name" {
  description = "Name for an automatically created database on cluster creation"
  type        = string
  default     = ""
}

variable "backend_root_password" {
  description = "Master DB password"
  type        = string
  default     = ""
}

variable "allowed_cidr_blocks" {
  description = "Allow CIDR in RDS network"
  type = list
  default = ["10.97.0.0/16"]
}

######### EKS details #############

variable "k8s_version" {
  type        = string
  description = "Desired Kubernetes master version."
  default     = "1.20"
}

variable "create_elb_service_linked_role" {
  type        = bool
  description = "Whether to create the service linked role for the elasticloadbalancing service. Without this EKS cannot create ELBs."
  default     = true
}

variable "public_access_cidrs" {
  type        = list
  description = "List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled"
  default     = ["0.0.0.0/0"]
}

############# EKS node group #############

variable "node_group_name" {
  type        = string
  description = "Name of the EKS Node Group"
  default     = "stuffnz-qa-dev"
}

variable "scaling_config" {
  type        = map(string)
  description = "Configuration block with scaling settings"
  default = {
    "desired_size" = 3
    "max_size"     = 6
    "min_size"     = 3
  }
}

variable "disk_size" {
  type        = number
  description = "Disk size in GiB for worker nodes. Defaults to 40. Terraform will only perform drift detection if a configuration value is provided"
  default     = 180
}

variable "instance_types" {
  type        = list
  description = "Set of instance types associated with the EKS Node Group. Defaults to [\"t3.medium\"]"
  default     = ["t3a.medium"]
}

variable "labels" {
  type        = map(string)
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument."
  default = {
    "node_group" = "qa-dev"
  }
}

variable "release_version" {
  type        = string
  description = "AMI version of the EKS Node Group. Defaults to latest version for Kubernetes version"
  default     = "1.18.9-20210125"
}

variable "remote_access" {
  type        = map
  description = "Configuration block with remote access settings"
  default = {
    "ec2_ssh_key"               = null
    "source_security_group_ids" = null
  }
}
