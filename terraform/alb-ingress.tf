resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.project_name}-aws-load-balancer-controller"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = module.eks.oidc_provider_arn
        }
        Condition = {
          StringEquals = {
            "${module.eks.oidc_provider}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${module.eks.oidc_provider}:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/AWSLoadBalancerControllerIAMPolicy"
  role       = aws_iam_role.aws_load_balancer_controller.name
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("${path.module}/policies/aws-load-balancer-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_custom" {
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
  role       = aws_iam_role.aws_load_balancer_controller.name
}

resource "aws_route53_zone" "main" {
  name = "project-bedrock.local"

  tags = {
    Project = var.project_name
  }
}
