terraform {
  required_version = "0.12.8"
  backend "s3" {
    bucket  = "practice-katsuya-tfstate"
    region  = "ap-northeast-1"
    key     = "prod/terraform.tfstate"
    profile = "private-aws_SA_001"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "private-aws_SA_001"
}

module "vpc" {
  source = "../modules/vpc"

  env                             = "prod"
  vpc_cidr_block                  = "10.0.0.0/16"
  subnet_cidr_block_public_a      = "10.0.1.0/24"
  subnet_cidr_block_public_c      = "10.0.2.0/24"
  subnet_cidr_block_private_app_a = "10.0.10.0/24"
  subnet_cidr_block_private_app_c = "10.0.20.0/24"
  subnet_cidr_block_private_db_a  = "10.0.30.0/24"
  subnet_cidr_block_private_db_c  = "10.0.40.0/24"
  az_a                            = "ap-northeast-1a"
  az_c                            = "ap-northeast-1c"
}

#module "security_group" {
#  source = "../modules/network/security_group"
#  vpc_id = "${module.vpc.vpc_id}"
#}


#module "ec2" {
#  source             = "./ec2"
#  public01_subnet_id = "${module.vpc.public01_subnet_id}"
#  sercurity_group_id = "${module.security_group.security_group_id}"
#}

#module "code" {
#  source = "./code"
#}
