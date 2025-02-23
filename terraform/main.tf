# Retrieve the latest image from HCP Packer
# Retrieve the latest version from HCP Packer
data "hcp_packer_version" "latest" {
  bucket_name  = "learn-packer-ubuntu"
  channel_name = "latest"
}

# Retrieve the corresponding artifact for AWS in the desired region
data "hcp_packer_artifact" "latest_ami" {
  bucket_name         = "learn-packer-ubuntu"
  version_fingerprint = data.hcp_packer_version.latest.fingerprint
  platform            = "aws"
  region              = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = data.hcp_packer_artifact.latest_ami.external_identifier
  instance_type = "t2.micro"
  key_name      = "test"
  tags = {
    Name = "Ubuntu-HCP-AMI"
  }
}
