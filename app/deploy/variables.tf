variable "cluster_name" {
  description = "Nome do cluster ECS"
  type        = string
  default = "app-prod"
}

variable "desired_count" {
  description = "desired tasks"
  type   = number
  default = 3
}

variable "subnets_id" {
  description = "Subnets IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}
}