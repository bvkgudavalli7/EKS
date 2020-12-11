provider "aws" {  
  region = "us-east-1"   
  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account}:role/jenkins-terraform"
  }
} 

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
