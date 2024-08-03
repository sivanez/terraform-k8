//aws provider
variable "aws_region" {
    default = "ap-south-1"
}

//cidr
variable "vpc_cidr" {
    default  = "10.0.0.0/16"
}

//key
variable "key_name"{}