# For now all variables are taken from a json file

# Variables with default values
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2" # eu-central-1
}

variable "frontned_vpc_id" {
  type        = string
  description = "ID of the frontend VPC"
  default     = "vpc-050509d34c758264b"
}

variable "backend_vpc_id" {
  type        = string
  description = "ID of the backend VPC"
  default     = "vpc-0e8c598851cb56f32"
}

variable "aws_az1" {
  type        = string
  description = "First AZ"
  default     = "eu-west-2a"
}

variable "aws_az2" {
  type        = string
  description = "Second AZ"
  default     = "eu-west-2b"
}

variable "images" {
  type        = map
  description = "Images to be used for instances"
  default     = {
      "eu-central-1" = "ami-0a49b025fffbbdac6",
      "eu-west-2"    = "ami-0fdf70ed5c34c5f52",
      "eu-west-1"    = "ami-08edbb0e85d6a0a07"
  }
}

variable "rds-sg-id" {
  type        = map
  description = "Sg to be used for the RDS instance"
  default     = {
      "postgres"  = "sg-022aff9cf36f184c5",
      "mysql"     = "sg-0480a6df18637d299"
  }
}


# Taken from DB
variable "frontend_sub1_cidr" {
  type        = string
  description = "Cidr block for the first frontend subnet"
}

variable "frontend_sub2_cidr" {
  type        = string
  description = "Cidr block for the second frontend subnet"
}

variable "backend_sub1_cidr" {
  type        = string
  description = "Cidr block for the first backend subnet"
}

variable "backend_sub2_cidr" {
  type        = string
  description = "Cidr block for the second backend subnet"
}

variable "backend_sub3_cidr" {
  type        = string
  description = "Cidr block for the third backend subnet"
}

variable "backend_sub4_cidr" {
  type        = string
  description = "Cidr block for the fourth backend subnet"
}


# Taken from app input
variable "client" {
  type        = string
  description = "Client tag to be added to resources"
}

variable "server_type" {
  type        = string
  description = "The type of instance to be used for the app servers"
}

variable "key" {
  type        = string
  description = "Public SSH key to be used for the creation of the machines"
}

variable "key_name" {
  type        = string
  description = "Name to be given to the generated private SSH key"
}

variable "frontend_server" {
  type        = string
  description = "Server to be used for the frontend instances"
}

variable "db_engine" {
  type        = string
  description = "Endine to be used for the RSD instance"
}

variable "db_username" {
  type        = string
  description = "Username for the database"
}

variable "db_pass" {
  type        = string
  description = "Password for the database"
}