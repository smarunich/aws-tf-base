provider "aws" {
  profile = coalesce(var.aws_profile, "")
  region  = var.aws_region
}

module "aws_utilities" {
  source = "./modules/aws/util"
}

module "aws_key_pair" {
  count    = var.aws_key_pair_reuse == false ? 1 : 0
  source   = "./modules/aws/key"
  key_name = "${var.name_prefix}-generated-key"
}

module "aws_vpc" {
  source       = "./modules/aws/vpc"
  vpc_cidr     = var.cidr
  min_az_count = 1
  max_az_count = 3
  name_prefix  = var.name_prefix
  aws_tags     = merge(var.aws_tags, { "cluster_uuid" : module.aws_utilities.random_uuid })
}


