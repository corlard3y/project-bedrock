variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "project-bedrock"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
  default     = "your-github-org"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "project-bedrock"
}

variable "mysql_password" {
  description = "Password for MySQL RDS instance"
  type        = string
  sensitive   = true
  default     = "ProjectBedrock123!"
}

variable "postgres_password" {
  description = "Password for PostgreSQL RDS instance"
  type        = string
  sensitive   = true
  default     = "ProjectBedrock123!"
}
