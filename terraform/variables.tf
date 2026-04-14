variable "namespace" {
  description = "Kubernetes namespace for the app"
  type        = string
  default     = "devops-app"
}

variable "image_repo" {
  description = "Docker image repository"
  type        = string
  default     = "alexander75977/devops-app"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "replicas" {
  description = "Number of replicas"
  type        = number
  default     = 2
}
