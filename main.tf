module "vpc" {
  source    = "./modules/network"
  project   = var.project
  region    = var.region
  zone      = var.zone
  vpc_name  = var.vpc_name
  auto_mode = false

  subnet_name = {
    subnet1 = {
      name          = "subnet1-tf-hw3"
      ip_cidr_range = "192.168.0.0/24"
      region        = "europe-central2"
      network       = "vpc-tf-hw3"
      project       = "tf-hw3-project"
    },
    subnet2 = {
      name          = "subnet2-tf-hw3"
      ip_cidr_range = "192.168.1.0/24"
      region        = "europe-central2"
      network       = "vpc-tf-hw3"
      project       = "tf-hw3-project"
    }
  }

  firewall_rules = [
    { protocol : "tcp",
      name : "firewall1-tf-hw3",
      ports : [80, 443],
      source_ranges : ["0.0.0.0/0"]
    },
    { protocol : "tcp",
      name : "firewall2-tf-hw3",
      ports : [22],
      source_ranges : ["31.148.245.228/32"]
  }]
}

module "gce" {
  source          = "./modules/google_compute"
  project         = var.project
  zone            = var.zone
  vpc_name        = var.vpc_name
  subnet_name_gce = module.vpc.subnet
  disk_name       = var.disk_name
  disk_type       = var.disk_type
  disk_size       = var.disk_size
  gce_instance = {
    gce1 = {
      instance_name           = "gce1-tf-hw3"
      instance_type           = "f1-micro"
      zone                    = "europe-central2-a"
      boot_image              = "debian-cloud/debian-9"
      metadata_startup_script = var.startup_script
      subnet_key              = "subnet1"
    },
    gce2 = {
      instance_name           = "gce2-tf-hw3"
      instance_type           = "f1-micro"
      zone                    = "europe-central2-a"
      boot_image              = "debian-cloud/debian-9"
      metadata_startup_script = var.startup_script
      subnet_key              = "subnet2"
    }
  }
}

//Storage Bucket
resource "google_storage_bucket" "storage-buckets-tf-hw3" {
  count                       = var.bucket_count
  name                        = "storage-bucket-hw3-${count.index}"
  location                    = "EU"
  force_destroy               = true
  uniform_bucket_level_access = true
}

data "google_compute_network" "vpc-data" {
  name = "vpc-data"
}

resource "google_compute_subnetwork" "data-source-subnet" {
  name          = "vpc-data-subnet"
  ip_cidr_range = "172.20.1.0/24"
  region        = "europe-central2"
  network       = data.google_compute_network.vpc-data.id
}

resource "google_compute_firewall" "data-source-firewall" {
  name    = "data-source-firewall"
  network = data.google_compute_network.vpc-data.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
}