variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to deploy resources"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_1_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR block for public subnet 1"
}

variable "public_subnet_2_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR block for public subnet 2"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "EC2 Instance type"
}

variable "ssh_key_name" {
  type        = string
  default     = "aws-alb-docker"
  description = "The name of the SSH key pair registered in AWS to access instances"
}

variable "ssh_key_path" {
  type        = string
  default     = "aws-alb-docker.pem"
  description = "Path to the local SSH private key file used by Ansible"
}

variable "host_header_project1" {
  type        = string
  default     = "project1.test.uk"
  description = "Host header for Project 1 routing rule"
}

variable "host_header_project2" {
  type        = string
  default     = "project2.test.uk"
  description = "Host header for Project 2 routing rule"
}
