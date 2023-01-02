terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.13"
}
/*does not work with this */
/**terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.40.0"
    }
  }
} **/

provider "aws" {
  region = var.region
  profile = var.profile
}

/** # Backend that stores the state file in S3 
terraform {
  backend "s3" {
    bucket = "mybucket-sinem-backend"
    key    = "path"
    region = "us-east-1"
    profile = "default"
  }
}
**/

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

resource "aws_s3_bucket" "test" {
  bucket = "${data.aws_caller_identity.current.account_id}-sinem-bucket"
}
