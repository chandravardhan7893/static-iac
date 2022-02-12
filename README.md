<!-- PROJECT Intro -->
<br />
<div align="center">
  <h3 align="center">Terraform Infrastructure For AWS</h3>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
         <li><a href="#usage">Usage</a></li>
      </ul>
    </li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project
<p align="right">(<a href="#top">back to top</a>)</p>

### Built With
* [Terraform](https://www.terraform.io/)
* [AWS](https://ap-southeast-2.console.aws.amazon.com/console/home)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->
## Getting Started
Terraform setup for stuffnz on AWS
### Prerequisites
* Install [Terraform](https://www.terraform.io/downloads.html)
### Installation
1. Configure AWS access and secret key in your laptop
   ```sh
   aws configure
   ```
2. git clone IAAC repo
   ```sh
   git clone git@github.com:StuffNZ/stuff-iaac.git
   ```
3. update your [env].terraform.tfvars file
   ```terraform
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
    backend_root_password = "xxxxxx"

    release_version       = "1.20.10-20211013"
    disk_size             = 80
    k8s_version           = "1.20"
    instance_types = ["t3.xlarge"]
    scaling_config  = { "desired_size" = 3, "max_size" = 6, "min_size" = 3 }
   ```
4. Run the terraform 
   ```sh
   terraform plan -var-file=qa-dev.terraform.tfvars
   terraform apply -var-file=qa-dev.terraform.tfvars
   ```

<p align="right">(<a href="#top">back to top</a>)</p>
