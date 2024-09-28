variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-2"  # Ohio Region
}

variable "availability_zones" {
  description = "List of preferred availability zones"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

# EC2 Instance Configuration
variable "instance_type" {
  description = "The type of instance to use"
  type        = string
  default     = "t2.medium"
}

variable "ami_id" {
  description = "The AMI ID to use for the instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"
}

# Tags
variable "environment" {
  description = "The environment of the infrastructure"
  type        = string
  default     = "prod"
}

variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    ami             = string
    instance_type   = string
    key_name        = string
  }))
  default = {
    "vm-1" = {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
      key_name      = "my-key"
    }
    "vm-2" = {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
      key_name      = "my-key"
    }
  }
}
