resource "tls_private_key" "gen_ssh_key" {
  algorithm = "ED25519"
}

resource "local_file" "ssh_key" {
  filename        = "./ssh-keys/hcloud-ed25519"
  content         = tls_private_key.gen_ssh_key.private_key_openssh
  file_permission = "0600"
}
