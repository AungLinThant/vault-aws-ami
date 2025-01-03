# https://developer.hashicorp.com/packer/integrations/hashicorp/amazon/latest/components/builder/ebs

source "amazon-ebs" "ubuntu-image" {
  ami_name = "${var.owner}-vault-{{timestamp}}"
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
  instance_type = var.aws_instance_type
  tags = {
    Name = "${var.owner}-vault"
  }
  source_ami_filter {
      filters = {
        virtualization-type = "hvm"
        // name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
        name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
        root-device-type = "ebs"
      }
      owners = ["099720109477"]
      most_recent = true
  }
  communicator = "ssh"
  ssh_username = "ubuntu"
}

build {
  sources = [
    "source.amazon-ebs.ubuntu-image"
  ]
  provisioner "shell" {
    inline = [
      "sleep 10",
      "wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg",
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main\" | sudo tee /etc/apt/sources.list.d/hashicorp.list",
      "sudo apt update",
      "sudo apt install unzip -y",
      "sudo apt install wget -y",
      "sudo apt install net-tools -y",
      "sudo apt install jq -y",
      "sudo apt list -a vault",
      "sudo apt show vault",
      "sudo apt install vault=${var.vault_version}",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable vault.service",
      "sudo systemctl start vault.service",
      "sudo systemctl status vault.service"
    ]
  }
}
