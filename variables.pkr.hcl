variable "owner" {
  type        = string
  description = "Owner tag to which the artifacts belong"
  default     = "hellocloud"
}
variable "vault_version" {
  type = string
  description = "Three digit vault version to work with"
  default = "1.17.0-1"
}
variable "aws_region" {
  type        = string
  description = "AWS Region for image"
  default     = "ap-southeast-1"
}
variable "aws_profile" {
  type        = string
  description = "AWS profile"
  default     = "default"
}
variable "aws_instance_type" {
  type        = string
  description = "Instance Type for Image"
  default     = "t2.small"
}