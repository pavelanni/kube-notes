## Deploys servers on Hetzner Cloud
# The SSH key to upload to the cloud
resource "hcloud_ssh_key" "default" {
  name       = "generated public key"
  public_key = tls_private_key.gen_ssh_key.public_key_openssh
}

# Cloud-init script
locals {
  hcloud_init_content = templatefile("./assets/templates/cloud-init.tmpl", {
    user    = var.user
    ssh-pub = tls_private_key.gen_ssh_key.public_key_openssh
  })
}

# Private network
resource "hcloud_network" "network" {
  name     = "network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "network-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# Create the jumpbox host
resource "hcloud_server" "jumpbox" {
  name        = "jumpbox"
  image       = var.hcloud_os_type
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.2"
  }
  ssh_keys  = [hcloud_ssh_key.default.id]
  user_data = local.hcloud_init_content

  depends_on = [hcloud_network_subnet.network-subnet]

}

# Create the server host (control plane)
resource "hcloud_server" "server" {
  name        = "server"
  image       = var.hcloud_os_type
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.3"
  }
  ssh_keys  = [hcloud_ssh_key.default.id]
  user_data = local.hcloud_init_content
}

# Create the node hosts (workers)
resource "hcloud_server" "node" {
  count       = var.hcloud_node_count
  name        = "node-${count.index}"
  image       = var.hcloud_os_type
  server_type = var.hcloud_server_type
  location    = var.hcloud_location
  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }
  network {
    network_id = hcloud_network.network.id
    ip         = "10.0.1.${count.index + 4}"
  }
  ssh_keys  = [hcloud_ssh_key.default.id]
  user_data = local.hcloud_init_content
}

# Output the IP
output "jumpbox_ip_address" {
  value = hcloud_server.jumpbox.ipv4_address
}

# Output the SSH key location
output "ssh_key" {
  value = local_file.ssh_key.filename
}
