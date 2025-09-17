# EKS Cluster Information
output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_iam_role_name" {
  description = "IAM role name associated with EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}

# VPC Information
output "vpc_id" {
  description = "ID of the VPC where the cluster is deployed"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# IAM Information
output "github_actions_role_arn" {
  description = "ARN of the GitHub Actions IAM role"
  value       = aws_iam_role.github_actions_oidc.arn
}

output "dev_readonly_user_name" {
  description = "Name of the read-only developer IAM user"
  value       = aws_iam_user.dev_readonly.name
}

output "dev_readonly_access_key_id" {
  description = "Access key ID for the read-only developer user"
  value       = aws_iam_access_key.dev_readonly_key.id
  sensitive   = true
}

output "dev_readonly_secret_access_key" {
  description = "Secret access key for the read-only developer user"
  value       = aws_iam_access_key.dev_readonly_key.secret
  sensitive   = true
}

# Kubeconfig command
output "kubeconfig_command" {
  description = "Command to update kubeconfig for the EKS cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# RDS Information
output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.endpoint
}

# DynamoDB Information
output "dynamodb_carts_table" {
  description = "DynamoDB carts table name"
  value       = aws_dynamodb_table.carts.name
}

output "dynamodb_sessions_table" {
  description = "DynamoDB sessions table name"
  value       = aws_dynamodb_table.sessions.name
}

# ALB and Certificate Information
output "certificate_arn" {
  description = "ARN of the SSL certificate"
  value       = aws_acm_certificate.main.arn
}

output "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.main.zone_id
}

output "domain_name" {
  description = "Domain name for the application"
  value       = "project-bedrock.local"
}

output "alb_controller_role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role"
  value       = aws_iam_role.aws_load_balancer_controller.arn
}
