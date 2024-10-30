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
    ssh_user        = null
    ssh_key       = null
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
    }
  ]
  labels = {
    environment = "development"
    scope       = "dev"
  }
  secondary_disks = [
    {
      disk_id     = null
      auto_delete = true
      device_name = "secondary-disk"
      mode        = "READ_WRITE"
      size        = 100          
      block_size  = 4096        
      type        = "network-hdd" 
    },
    {
      disk_id     = null
      auto_delete = true
      device_name = "third-disk"
      mode        = "READ_WRITE"
      size        = 100          
      block_size  = 4096        
      type        = "network-hdd" 
    },
    {
      disk_id     = yandex_compute_disk.secondary.id
      auto_delete = true
      device_name = "secondary-disk-2"
      mode        = "READ_WRITE"
    }
  ]
  filesystems = [
    {
      filesystem_id = null 
      mode = "READ_WRITE"
    },   
    {
      filesystem_id = null 
      mode = "READ_WRITE"
    },
    {
      filesystem_id = yandex_compute_filesystem.secondary.id
      mode          = "READ_WRITE"
    }
  ]
}

resource "yandex_compute_disk" "secondary" {
  name               = "secondary-disk-2"
  description        = "secondary disk"
  folder_id          = "b1gacgku08inenk2320f"
  zone               = var.yc_zone
  size               = var.size
  block_size         = "4096"
  type               = "network-hdd"
}

resource "yandex_compute_filesystem" "secondary" {
  name        = "secondary-filesystem"
  description = "Secondary filesystem for dev"
  folder_id   = "b1gacgku08inenk2320f"
  zone        = var.yc_zone
  size        = 50
  type        = "network-ssd"
}
