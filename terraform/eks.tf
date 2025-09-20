module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = "project-bedrock-eks"
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      desired_capacity = 2
      min_size         = 1
      max_size         = 5
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
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/johndoe"
        username = "johndoe"
        groups   = ["system:masters"]
      },
      {
        userarn  = aws_iam_user.dev_readonly.arn
        username = aws_iam_user.dev_readonly.name
        groups   = ["system:authenticated"]
      }
    ])
  }

  depends_on = [module.eks]
}
