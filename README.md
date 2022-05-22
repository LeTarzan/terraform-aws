# terraform-aws
Create a mini infrastructure at AWS with terraform

---------------------------------------------------

### This project creates the following resources at AWS:

- VPC (public)
- Subnet
- Internet Gateway
- Route Table (with associations)
- Security Group
- Key Pair (SSH)
- EC2 Instance (t2.micro / ubuntu-22.04 | with docker installed)

### To run make this:

- In *main.tf > aws_key_pair* put your SSH public key file
- In *main.tf > aws_security_group* put your ip if you want block public access
- In *providers.tf > aws* put your aws credential file 

after that, run:

`terraform plan`

`terraform apply -auto-approve`
