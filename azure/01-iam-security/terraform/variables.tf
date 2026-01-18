variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "cloudsec-labs"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "lab"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-cloudsec-labs"
}
