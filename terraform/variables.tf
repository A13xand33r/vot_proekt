variable "namespace" {
  type    = string
  default = "devops-app"
}

variable "image_repo" {
  type    = string
  default = "alexander75977/devops-app"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "replicas" {
  type    = number
  default = 2
}
