# OIDC Identity Provider for GitHub Actions
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]

  tags = {
    Project = var.project_name
  }
}

# IAM role for GitHub Actions OIDC to assume
resource "aws_iam_role" "github_actions_oidc" {
  name = "${var.project_name}-github-oidc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/*"
        }
      }
    }]
  })

  tags = {
    Project = var.project_name
  }
}

# Policy for Terraform actions (least privilege can be tightened)
resource "aws_iam_role_policy" "github_actions_terraform_policy" {
  name = "${var.project_name}-terraform-policy"
  role = aws_iam_role.github_actions_oidc.id

  policy = file("${path.module}/policies/terraform-policy.json")
}

# IAM user for developers (read-only)
resource "aws_iam_user" "dev_readonly" {
  name = "dev-readonly"
  path = "/project-bedrock/"
}

resource "aws_iam_user_policy" "dev_readonly_policy" {
  name = "dev-readonly-inline"
  user = aws_iam_user.dev_readonly.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListFargateProfiles",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups",
          "logs:GetLogEvents",
          "logs:FilterLogEvents",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

# Optional: Create access key for dev user — WARNING: stored in state
resource "aws_iam_access_key" "dev_readonly_key" {
  user = aws_iam_user.dev_readonly.name
  # You can output the secret access key - be careful
}
