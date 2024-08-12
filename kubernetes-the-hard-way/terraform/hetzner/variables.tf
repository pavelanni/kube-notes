# General User variables
variable "user" { default = "root" }

# Hetzner (hcloud) variables
variable "hcloud_token" {}
variable "hcloud_node_count" { default = "2" }
variable "hcloud_location" { default = "fsn1" }
variable "hcloud_server_type" { default = "cax11" }
variable "hcloud_os_type" { default = "debian-12" }
