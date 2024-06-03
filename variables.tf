variable "keypair_name" {
  type        = string
  description = "The keypair to use for creating the server and allowing SSH"
  default     = "minecraft-key"
}

variable "pem_location" {
  type        = string
  description = "The location of the PEM file to use for SSH"
  default     = "~/.ssh/server.pem"
}
