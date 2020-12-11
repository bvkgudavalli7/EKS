variable "cluster" {
  description = "The kubernetes cluster configuration"
  type = object({
    name            = string
    admin-iam-roles = list(string)
    version         = string
  })
}

variable "node-groups" {
  description = "Cluster node group configuration"
  type = list(object({
    name                    = string
    instance-type           = string
    count-desired           = number
    count-min               = number
    count-max               = number
    iam-role                = string
    ec2-ssh-key             = string
    ec2-ssh-security-groups = list(string)
    labels                  = map(string)
  }))
}

variable "vpc" {
  description = "VPC configuration"
  type = object({
    id              = string
    subnets-all     = list(string)
    subnets-private = list(string)
  })
}

variable "public-access-cidrs" {
  description = "The a list of CIDR addresses that are allowed to communicate to the public API"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}
