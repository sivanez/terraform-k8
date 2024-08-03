//https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = local.cluster_name
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.worker_nodes_sg.id]
}

  eks_managed_node_groups = {
    example = {
    
      min_size     = 2
      max_size     = 6
      desired_size = 2
    }
  }


}