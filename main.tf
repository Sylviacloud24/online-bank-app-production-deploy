# ===============================
# Terraform Main Configuration
# ===============================

# -------------------------------
# VPC Deployment
# -------------------------------
module "vpc-deployment" {
  source = "./module-vpc"

  environment       = var.environment
  vpc_cidrblock     = var.vpc_cidrblock
  countsub          = var.countsub
  create_subnet     = var.create_subnet
  create_elastic_ip = var.create_elastic_ip
}

# -------------------------------
# EKS Deployment
# -------------------------------
# This module deploys an EKS cluster in the VPC created above
module "eks-deployment" {
  source = "./module-eks"

  environment        = var.environment
  vpc_cidrblock      = var.vpc_cidrblock
  countsub           = var.countsub
  create_subnet      = var.create_subnet
  create_elastic_ip  = var.create_elastic_ip
  desired_size       = var.desired_size
  max_size           = var.max_size
  min_size           = var.min_size
  instance_types     = var.instance_types
  capacity_type      = var.capacity_type
  public_subnet_ids  = module.vpc-deployment.public_subnet_ids
  private_subnet_ids = module.vpc-deployment.private_subnet_ids
  cluster_name       = var.cluster_name
  repository_name    = var.repository_name
  domain-name        = var.domain_name
  email              = var.email
}

# -------------------------------
# Namecheap Deployment (Commented Out)
# -------------------------------
# The Namecheap module is disabled because API keys are not used.
# You can enable this later if you integrate Namecheap or Route 53.
#
# module "namecheap-deployment" {
#   source                               = "./module-dns"
#   environment                          = var.environment
#   domain_name                          = var.domain_name
#   nginx_lb_ip                          = module.eks-deployment.nginx_lb_ip
#   nginx_ingress_load_balancer_hostname = module.eks-deployment.nginx_ingress_load_balancer_hostname
#   nginx_ingress_lb_dns                 = module.eks-deployment.nginx_ingress_lb_dns
# }

# -------------------------------
# RDS MySQL Deployment
# -------------------------------
module "rds-mysql-deployment" {
  source                 = "./module-database"
  environment            = var.environment
  db_instance_class      = var.db_instance_class
  db_allocated_storage   = var.db_allocated_storage
  private_subnet_db_ids  = module.vpc-deployment.private_subnet_db_ids
  db_name                = var.db_name
  db_password            = var.db_password
  db_username            = var.db_username
  aws_security_group_ids = module.vpc-deployment.aws_security_group_ids
}
