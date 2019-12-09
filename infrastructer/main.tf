terraform {
  required_version = "0.12.8"
  backend "s3" {
    bucket  = "practice-katsuya-tfstate"
    region  = "ap-northeast-1"
    key     = "terraform.tfstate"
    profile = "private-aws_SA_001"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "private-aws_SA_001"
}

module "vpc" {
  source = "./network/vpc"
}

module "security_group" {
  source = "./network/security_group"
  vpc_id = "${module.vpc.vpc_id}"
}


module "ec2" {
  source             = "./ec2"
  public01_subnet_id = "${module.vpc.public01_subnet_id}"
  sercurity_group_id = "${module.security_group.security_group_id}"
}

module "code" {
  source = "./code"
}
