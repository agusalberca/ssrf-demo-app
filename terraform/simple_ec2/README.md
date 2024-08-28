# Context
This stack deploys a simple EC2 instace in the default VPC and default public subnet.
This instance is deployed with a security group that allows only ingress and egress traffic from and to a specific IP addess. This is meant to be only accesible from your IP.
> Take into account that this instance will be publicly accesible if not setup correctly.

# Requirements
- AWS Cli installed and logged into your account: This is used by terraform to access your account and deploy infrastructure.
- Terraform 1.5.5 installed. (Recommendation: use tfenv for managing terraform versions)

# Setup
- Log into AWS management console and create a key-pair. Save it's name
- Modify `variables.tf` as desired.
    - Key-pair name should be replaced in the `key_name` variable.
- Run locally: `terraform apply`

# Disclaimer
Don't mind executing `terraform destroy` after using this stack. 
It won't delete default resources. It's safe :)