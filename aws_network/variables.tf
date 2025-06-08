variable "env" {
  type = string
  description = "Deployment Environment"
}
variable "prefix" {
  type = string
  description = "A prefix used for naming resources"
}
variable "vpc_cidr" {
  type = string
  description = "VPC to host static web site"
}
variable "public_subnet_cidrs" {
  type = list(string)
  description = "Public Subnet CIDRs"
}
variable "default_tags" {
  type = map(any)
  description = "Default tags to be applied to all AWS resources"
}
variable "region" {
  type = string
  description = "AWS Region to deploy in"
}
