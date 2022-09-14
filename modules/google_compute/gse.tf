resource "google_compute_attached_disk" "gce-disk-attached" {
  disk     = google_compute_disk.gce-disk.id
  instance = google_compute_instance.gce-tf-hw3["gce1"].id
}

resource "google_compute_disk" "gce-disk" {
  name  = var.disk_name
  type  = var.disk_type
  zone  = var.zone
  size  = var.disk_size
  }

resource "google_compute_instance" "gce-tf-hw3" {
  for_each     = var.gce_instance
  name         = each.value.instance_name
  machine_type = each.value.instance_type
  zone         = each.value.zone

  boot_disk {
    initialize_params {
      image = each.value.boot_image
    }
  }
  network_interface {
    network = var.vpc_name
    subnetwork = var.subnet_name_gce[each.value.subnet_key].self_link
  }

  metadata_startup_script = each.value.metadata_startup_script
}