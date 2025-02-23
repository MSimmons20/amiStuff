# amiStuff

# **Terraform & HCP Packer Pipeline with Secure AWS Credentials**

## **Overview**
This project automates the creation of AWS AMIs using **HCP Packer** and deploys EC2 instances using **Terraform**. The CI/CD pipeline is designed to securely manage AWS credentials and avoid hardcoding sensitive information.

---

## **Project Components**
### **1. HCP Packer Template (`ubuntu-hcp.pkr.hcl`)**
- Defines an AMI using **Packer**
- Installs **Ansible** on the instance
- Pushes the AMI to **HCP Packer**

### **2. Terraform Configuration (`main.tf`)**
- Fetches the latest AMI from **HCP Packer**
- Launches an **AWS EC2 instance**

### **3. CI/CD Pipeline (GitHub Actions)**
- Automates the **Packer Build** and **Terraform Deployment**
- Uses **GitHub Secrets** for secure AWS authentication

---

## **Setup & Installation**
### **1. Install Dependencies**
Ensure you have the following installed:
```sh
# Install Terraform, Packer, and AWS CLI
sudo apt update && sudo apt install -y terraform packer awscli
```

### **2. Configure AWS Credentials (Securely)**
Set your AWS credentials as **environment variables**:
```sh
export AWS_ACCESS_KEY_ID="your-aws-access-key"
export AWS_SECRET_ACCESS_KEY="your-aws-secret-key"
```
Or configure them using the AWS CLI:
```sh
aws configure
```

---

## **Building & Deploying**
### **1. Build the AMI with HCP Packer**
```sh
export HCP_CLIENT_ID="your-hcp-client-id"
export HCP_CLIENT_SECRET="your-hcp-client-secret"

packer init ubuntu-hcp.pkr.hcl
packer build ubuntu-hcp.pkr.hcl
```

### **2. Deploy with Terraform**
```sh
terraform init
terraform apply -auto-approve
```

### **3. Verify Deployment**
Check if the EC2 instance is running:
```sh
aws ec2 describe-instances --filters "Name=tag:Name,Values=Ubuntu-HCP-AMI"
```

---

## **GitHub Secrets & CI/CD Security**
To prevent AWS credential leaks, store them as **GitHub Secrets**:
1. Navigate to **GitHub Repository > Settings > Secrets and Variables**
2. Add the following secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `HCP_CLIENT_ID`
   - `HCP_CLIENT_SECRET`

### **GitHub Actions Workflow Example (`.github/workflows/deploy.yml`)**
```yaml
name: Deploy Terraform & Packer

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo
        uses: actions/checkout@v3

      - name: Install Dependencies
        run: |
          sudo apt update && sudo apt install -y packer terraform awscli

      - name: Build AMI with Packer
        env:
          HCP_CLIENT_ID: ${{ secrets.HCP_CLIENT_ID }}
          HCP_CLIENT_SECRET: ${{ secrets.HCP_CLIENT_SECRET }}
        run: |
          packer init ubuntu-hcp.pkr.hcl
          packer build ubuntu-hcp.pkr.hcl

      - name: Deploy with Terraform
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          terraform init
          terraform apply -auto-approve
```

---

## **Final Thoughts**
✅ **Automated AMI Creation with HCP Packer**  
✅ **Secure AWS Authentication with GitHub Secrets**  
✅ **CI/CD Deployment with Terraform & GitHub Actions**  

Would you like additional features such as auto-scaling or monitoring? 🚀


