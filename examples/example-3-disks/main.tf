module "dev" {
  source        = "../../"
  image_family      = "ubuntu-2204-lts"
  zone          = var.yc_zone
  name          = "dev"
  hostname      = "dev"
  is_nat        = false
  description   = "dev"
  memory        = 4
  gpus          = 0
  cores         = 2
  type          = "network-ssd"
  core_fraction = 100
  serial_port_enable = true
  allow_stopping_for_update = true
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
      subnet_id = "e9b1rvg1c0vpio65eks8"
      ipv4       = true
      nat        = true
      
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
  secondary_disks = [
    {
    disk_id     = yandex_compute_disk.dev.id
    auto_delete = true
    device_name = "secondary-disk"
    mode        = "READ_WRITE"
    }
  ]
  create_filesystem = true
  filesystem_name = "dev-filesystem"
  filesystem_description = "Filesystem for dev"
  filesystem_size = 50
  filesystem_type = "network-ssd"
  filesystems = [
    {
      filesystem_id = null 
      mode = "READ_WRITE"
    }
  ]
}


resource "yandex_compute_disk" "dev" {
  name               = "secondary-disk"
  description = "secondary-disk"
  folder_id   = "b1gacgku08inenk2320f"
  zone        = var.yc_zone
  size        = var.size
  block_size  = "4096"
  type        = "network-hdd"
}


/// при созздании secondary disk добавить еще map с именем дисков n+1 со всеми характеристикими. если в парамтерах seconday disks указал id, то его не надо сздавать а зацепить существуется через for each 
/// filesystem [check "name" {
   /// bla bla bla filesystems
//}]