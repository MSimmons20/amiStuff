packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "aws_access_key" {
  type    = string
  default = "AKIA2QZJM67B4JQ5JNVT"
}
variable "aws_secret_key" {
  type    = string
  default = "kWQX2/MTYOcJoiinTB2zlU6Z7lt/mba5BVBtk/FM"
}

# Define the AWS Source AMI
source "amazon-ebs" "ubuntu" {
  region     = var.aws_region # Change to your preferred AWS region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["099720109477"] # Canonical (Official Ubuntu Owner ID)
    most_recent = true
  }

  # Define block device mappings to specify EBS volume size
  # Set the root volume to 10GB
  ami_block_device_mappings {
    device_name           = "/dev/xvda"
    volume_size           = 10
    volume_type           = "gp2"
    delete_on_termination = true
  }

  instance_type = "t2.micro"
  ssh_username  = "ubuntu"
  ami_name      = "ubuntu-ansible-ami-{{timestamp}}"
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  hcp_packer_registry {
    bucket_name = "learn-packer-ubuntu"
    description = <<EOT
Some nice description about the image being published to HCP Packer Registry.
    EOT
    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu",
      "ubuntu-version" = "Focal 20.04",
    }
  }

  provisioner "shell" {
    inline = [
      "sudo apt update",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt update",
      "sudo apt install -y ansible",
      "ansible --version",
      "sudo apt-get install -y nginx",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}
