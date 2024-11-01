
This is a project I am gonna implement:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241029183637.png)

The example of the structure I can use:

``` r
terraform-project/
├── main.tf                  # Main configuration file
├── variables.tf             # Input variables for the project
├── outputs.tf               # Outputs from the project
├── terraform.tfvars         # Values for the input variables
├── provider.tf              # Provider configurations (e.g., AWS, Azure, etc.)
├── versions.tf              # Version constraints for Terraform and providers
├── backend.tf               # Configuration for the remote backend (e.g., S3, GCS)
├── modules/                 # Custom modules directory
│   ├── vpc/                 # Module example for VPC
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   └── ec2/                 # Module example for EC2
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
├── envs/                    # Environments directory
│   ├── dev/                 # Development environment
│   │   ├── main.tfvars
│   │   ├── backend.tfvars
│   └── prod/                # Production environment
│       ├── main.tfvars
│       ├── backend.tfvars
├── scripts/                 # Bash or other scripts for automation tasks
│   └── init.sh              # Script to initialize Terraform or run pre-tasks
└── README.md                # Documentation of the project

```

First I will create all resources in the main.tf file:

1) Define providers in providers.tf file:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030173927.png)

2) Create VPC and 4 Subnets (2 public, 2 private).

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030174043.png)

3) Create internet gateway and route table associated with these resources:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030174213.png)

4) Create security group

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241029230512.png)


5) Create load balancer, target group. 

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030174304.png)

6) Define launch template and auto scaling group.

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030174339.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030174404.png)


7) Define backend: define the s3 bucket and dynamodb

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030110109.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030110129.png)

8) Execute `terraform plan` and `terraform apply`

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030111025.png)

9) My app accessible with load balancer dns:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030173151.png)

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241030173325.png)

>[!info] Note
>Firstly my app didn't work as I forgot to add NAT gateways. Therefore I couldn't connect to my app as the bash script wasn't executed correctly because of the lack of the internet.
>So I added a NAT gateway.
## Next I will move some parts of the code to modules and add variables:

1) Created variables for my project

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101170011.png)

2) Let's modulize this code
I will use such structure:

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101173924.png)

3) Create VPC module

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195250.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195305.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195318.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195331.png)


4) Create security group module

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195424.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195450.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195504.png)


5) Create app load balancer module

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195708.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195719.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195733.png)

6) Create auto scaling module

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195825.png)
![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195846.png)

7) And now My main script looks like this

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101195918.png)

As variables I used module outputs and variables defined in the root (variables.tf and terraform.tfvars):

![](https://github.com/Briez-b/DevOpsNotes/blob/main/Attachments/Pasted%20image%2020241101200023.png)

My application works.
