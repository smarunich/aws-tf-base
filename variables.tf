
variable "aws_region" {
  default = "us-east-1"
}

variable "name_prefix" {
}

variable "cidr" {
  type    = string
  default = "10.255.0.0/16"
}

variable "aws_profile" {
}

variable "aws_key_pair_reuse" {
  type    = bool
  default = false
}

variable "aws_key_pair_name" {
  type    = string
  default = ""
}

variable "aws_key_pair_public_key" {
  type    = string
  default = ""
}

variable "aws_tags" {
  type    = map(any)
  default = {}
}

