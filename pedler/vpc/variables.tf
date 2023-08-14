variable "vpc_conf" {
  type = map(any)
  #   default = {
  #     "vpc_1" = {
  #       "cidr"                 = "10.0.0.0/16"
  #       "tenancy"              = "default"
  #       "enable_dns_support"   = true
  #       "enable_dns_hostnames" = true
  #     }
  #   }
  default = {
    "cidr"                 = "10.0.0.0/16"
    "tenancy"              = "default"
    "enable_dns_support"   = true
    "enable_dns_hostnames" = true
  }
}

variable "tags" {
  type = map(string)
  default = {
    "Project" = "pedler"
  }
}


variable "aws_provider_conf" {
  type = map(any)
  default = {
    "region"  = "eu-west-1"
    "profile" = "papacrom"
  }
}


variable "subnet_cidrs" {
  type = map(any)
  default = {
    "private" = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    "public"  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
