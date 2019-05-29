datacenter = "dc1"
data_dir   = "/mount/"


client {
  enabled       = true
  network_speed = 10
  options {
    "driver.raw_exec.enable" = "1"
  }
}


vault {
  enabled          = true
  #ca_path          = "/etc/certs/ca"
  #cert_file        = "/var/certs/vault.crt"
  #key_file         = "/var/certs/vault.key"
  address          = "http://127.0.0.1:8200"
  create_from_role = "nomad-cluster"
}