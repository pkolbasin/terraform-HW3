variable "project" {
   type = string
}

variable "region" {
  type  = string
}

variable "zone" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "auto_mode" {
  type = bool
  default = false
}

variable "subnet_name" {
    type = map(object(
  {
    name = string
    ip_cidr_range = string
    region = string
    network = string
    project = string
  }))
}

variable "firewall_rules" {
    type = list(object(
  {
    name = string
    protocol = string
    ports    = list(any)
    source_ranges = list(string)
  }))
}

variable "router_name" {
  type = string
  default = "tf-hw3-router"
}

variable "router_nat_name" {
  type = string
  default = "tf-hw3-nat"
}