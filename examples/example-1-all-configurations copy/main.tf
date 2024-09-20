module "dev" {
  source        = "../../"
  image_family      = "ubuntu-2404-lts-oslogin"
  zone          = var.yc_zone
  name          = "dev"
  hostname      = "dev"
  is_nat        = false
  description   = "dev"
  memory        = 8
  gpus          = 0
  cores         = 4
  type          = "network-ssd"
  core_fraction = 100
  serial_port_enable = true
  allow_stopping_for_update = true
  monitoring  = true
  backup      = false
  create_filesystem       = true
  filesystem_name         = "my-filesystem"
  filesystem_description  = "Filesystem for dev instance"
  filesystem_zone         = var.yc_zone
  filesystem_size         = 100
  filesystem_block_size   = 4096
  filesystem_type         = "network-hdd"


  enable_oslogin_or_ssh_keys = {
    enable-oslogin = "true"
    ssh-keys = null
  }
  metadata_options = {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  network_interfaces = [
    {
      subnet_id = yandex_vpc_subnet.sub_a.id
      ipv4       = true
      nat        = true
      
    },
    {
      subnet_id = yandex_vpc_subnet.sub_a.id
      ipv4       = true
      nat        = false
      dns_record = []
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
  static_ip = {
    name = "my-static-ip"
    description = "Static IP for dev instance"
    external_ipv4_address = {
      zone_id = var.yc_zone
    }
  }
}
