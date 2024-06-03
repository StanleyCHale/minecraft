provider "aws" {
  region = "us-east-1"  # Add my desired region
  shared_credentials_files = ["~/.aws/credentials"]
}

resource "aws_security_group" "minecraft_server" {
  name        = "minecraft_server"
  description = "Security group for Minecraft server"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP and HTTPS requests
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound rules
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#Create an elastic IP
resource "aws_eip" "minecraft_eip" {
  instance = aws_instance.minecraft_server.id
  tags = {
    Name = "minecraft-eip"
  }
}

#Associate our elastic IP with the minecraft server
resource "aws_eip_association" "minecraft_eip_association" {
  instance_id   = aws_instance.minecraft_server.id
  allocation_id = aws_eip.minecraft_eip.id
}

#Create our EC2 minecraft server instance
resource "aws_instance" "minecraft_server" {
  ami           = "ami-0bb84b8ffd87024d8"  # Amazon Linux 2 AMI ID
  instance_type = "t2.medium"  # Add my desired instance type
  key_name      = var.keypair_name  # Add my keypair

  vpc_security_group_ids = [aws_security_group.minecraft_server.id]

  tags = {
    Name = "minecraft-server"
  }
  
  provisioner "file" {
    source      = "~/minecraft/scripts/"
    destination = "/home/ec2-user/"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.pem_location)
      host        = aws_instance.minecraft_server.public_ip
	  agent       = false # Disable the SSH agent
    }
  }

  #Execute setup commands/scripts
  provisioner "remote-exec" {
    inline = [
	  "sudo yum -y install java-17-amazon-corretto-devel",
	  "wget https://download.getbukkit.org/spigot/spigot-1.20.4.jar",
      "chmod +x /home/ec2-user/scripts/server_setup.sh",
	  "chmod +x /home/ec2-user/scripts/launch.sh",
      "sudo /bin/bash /home/ec2-user/scripts/server_setup.sh",
	  "rm -rf /home/ec2-user/scripts/server_setup.sh",
	  "sudo /bin/bash /home/ec2-user/scripts/launch.sh &"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.pem_location)
      host        = self.public_ip
      agent       = false # Disable the SSH agent
    }
  }
}

output "server_ip" {
  description = "Elastic IP address of the EC2 instance"
  value       = aws_eip.minecraft_eip.public_ip
}
     
