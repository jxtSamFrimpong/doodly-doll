resource "aws_vpc" "main" {
  #for_each             = var.vpc_conf
  cidr_block           = var.vpc_conf["cidr"]
  instance_tenancy     = var.vpc_conf["tenancy"]
  enable_dns_hostnames = var.vpc_conf["enable_dns_hostnames"]
  enable_dns_support   = var.vpc_conf["enable_dns_support"]
  tags = merge({
    Name = "vpc_1"
    },
    var.tags
  )
}

