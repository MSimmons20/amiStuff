packer {
  required_plugins {
    docker = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "ubuntu" {
  image  = "ubuntu:latest"
  commit = true
}

build {
  name = "custom-ubuntu"
  sources = [
    "source.docker.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "apt update",
      "apt install -y ansible"
    ]
  }

  post-processor "docker-tag" {
    repository = "custom-ubuntu"
    tag        = "ansible-latest"
  }
}
