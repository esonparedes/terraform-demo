variable "instance_type" {
  type        = string
  description = "AWS Input Variable: EC2 Instance Type"
  default     = "t3.micro"
}

variable "aws_region" {
  type        = string
  description = "AWS Input Variable: Target AWS Region"
  default     = "us-east-1"
}

variable "public_key_local_path" {
  type        = string
  description = "Location of your public key."
  default     = "~/.ssh/id_rsa.pub"
}

variable "keypair_name" {
  type        = string
  description = "If you have your keypair already set on AWS, specify it here."
  default     = null
}