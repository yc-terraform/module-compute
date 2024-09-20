
resource "yandex_compute_disk" "this" {
  name               = var.name
  description = var.description
  folder_id   = local.folder_id
  zone        = var.zone
  size        = var.size
  block_size  = var.block_size
  type        = var.type
  image_id    = var.image_family != null ? data.yandex_compute_image.image[0].id : var.image_id
  snapshot_id = var.snapshot_id
  labels             = var.labels

  dynamic "disk_placement_policy" {
    for_each = var.disk_placement_policy != null ? [var.disk_placement_policy] : []
    content {
      disk_placement_group_id = disk_placement_policy.value.disk_placement_group_id
    }
  }
}

resource "yandex_compute_disk" "secondary" {
  count       = length(var.secondary_disks) 
  name        = format("%s-secondary-disk-%d", var.name, count.index + 1)
  description = lookup(var.secondary_disks[count.index], "description", null)
  folder_id   = local.folder_id
  zone        = var.zone
  size        = lookup(var.secondary_disks[count.index], "size", null)
  block_size  = lookup(var.secondary_disks[count.index], "block_size", null)
  type        = lookup(var.secondary_disks[count.index], "type", null)
  labels      = var.labels != null ? var.labels : null
}


resource "yandex_compute_filesystem" "this" {
  count       = var.create_filesystem ? length(var.filesystems) : 0 
  name        = format("%s-filesystem-%d", var.name, count.index + 1)
  description = lookup(var.filesystems[count.index], "description", var.filesystem_description)
  folder_id   = local.folder_id
  zone        = lookup(var.filesystems[count.index], "zone", var.zone)
  size        = lookup(var.filesystems[count.index], "size", var.filesystem_size)
  block_size  = lookup(var.filesystems[count.index], "block_size", var.filesystem_block_size)
  type        = lookup(var.filesystems[count.index], "type", var.filesystem_type)
  labels      = var.labels
}