

variable "project" {
  description = "GCP project id"
  type        = string
  default     = "nimble-analyst-356011"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-central2"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-central2-a"
}

variable "key" {
  description = "JSON key to service account"
  type        = string
  default     = "key.json"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "vpc-tf-hw3"
}

variable "disk_name" {
  description = "Disk name"
  type        = string
  default     = "tf-hw3-disk"
}

variable "disk_type" {
  description = "Disk type"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = string
  default     = "1"
}

variable "startup_script"{
  description = "Startup script"
  type = string
  default = "echo foo > ~/home/foo.txt"
}
variable "bucket_count" {
  description = "number of s3 buckets"
  type = number
  default = "1"
}