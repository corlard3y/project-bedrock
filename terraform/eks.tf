module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.5"

  cluster_name    = "project-bedrock-eks"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  manage_aws_auth = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_size         = 2
      max_size         = 3
      instance_types   = ["t3.medium"]
      capacity_type    = "ON_DEMAND"
    }
  }

  tags = {
    Project = "project-bedrock"
  }
}

# Data source to get the EKS cluster created by the module
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
  depends_on = [module.eks]
}
