variable "region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-east-1"  # Change the default if necessary
}

variable "my_ip" {
  description = "Your public IP address to allow access"
  type        = string
  default     = "0.0.0.0"  # Replace with your public IP address
}

variable "instance_type" {
  description = "The type of EC2 instance to launch"
  type        = string
  default     = "t4g.micro"
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
  default     = "agustin-key"  # Replace with your key pair name
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-023508951a94f0c71"  # Replace with a suitable AMI ID
}
