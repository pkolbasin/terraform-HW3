resource "google_compute_network" "vpc-tf-hw3" {
  project                 = var.project
  name                    = var.vpc_name
  auto_create_subnetworks = var.auto_mode
}

resource "google_compute_subnetwork" "subnet-tf-hw3" {
  for_each      = var.subnet_name
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = each.value.region
  network       = each.value.network
  project       = each.value.project

  depends_on    = [google_compute_network.vpc-tf-hw3]
}

locals {
  firewall_rules = {
    for x in var.firewall_rules:
        "${x.name}" => x
  }
}

resource "google_compute_firewall" "firewall_rules" {
  for_each = local.firewall_rules
  name    = each.value.name
  network = var.vpc_name
  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
    source_ranges = each.value.source_ranges

  depends_on    = [google_compute_subnetwork.subnet-tf-hw3]
}

resource "google_compute_router" "router-hw3" {
  name           = var.router_name
  region         = var.region
  network        = google_compute_network.vpc-tf-hw3.id
}

resource "google_compute_router_nat" "tf-hw3-nat" {
  name                               = var.router_nat_name
  router                             = google_compute_router.router-hw3.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.subnet_name
    content {
      name                    = subnetwork.value.name
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = "ALL"
  }
  depends_on    = [google_compute_firewall.firewall_rules]
}