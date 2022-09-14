variable "project" {
    type = string
}

variable "vpc_name" {
   type = string
}

variable "subnet_name_gce" {
    type = map
}

variable "gce_instance" {
    type = map(object(
  {
    instance_name = string
    instance_type = string
    zone = string
    boot_image = string
    metadata_startup_script = string
    subnet_key = string
  }
  )
  )
}

variable "disk_name" {
   type = string
}

variable "disk_type" {
    type = string
}

variable "zone" {
    type = string
}

variable "disk_size" {
    type = string
}