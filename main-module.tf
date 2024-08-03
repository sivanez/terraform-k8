//aws provider 
provider "aws" {
  region = var.aws_region
  access_key = "xxxxxxx"
  secret_key = "xxxxxxxx"
}

locals {
    cluster_name = "my-eks-cluster"
  }

//key pair
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

//private key
resource "local_file" "private_key" {
    content     = tls_private_key.rsa_4096.private_key_pem
    filename    = var.key_name
}
//private key encryption
resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//vpc setup
//https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
module "vpc" {
    
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr 

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  
  enable_nat_gateway = true
  //enable_vpn_gateway = true  //vpn not required
  single_nat_gateway = true //single gateway in public gateway
  //many specifications are available at https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

  tags = {
     //https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html#:~:text=have%20multiple%20AWS,shared%20or%20owned
     "kubernetes.io/cluster/${local.cluster_name}" ="shared"
  }

  //private subnet 
  private_subnet_tags = {
     //https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html#:~:text=Private%20subnets%20%E2%80%93%20Must,Value%20%E2%80%93%201
      "kubernetes.io/cluster/${local.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb" = "1"
  }

  //public subnet
  public_subnet_tags = {
   //https://docs.aws.amazon.com/eks/latest/userguide/alb-ingress.html#:~:text=Public%20subnets%20%E2%80%93%20Must,Value%20%E2%80%93%201
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  
}