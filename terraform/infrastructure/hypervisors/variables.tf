variable "os_images" {
  description = "The images configured onto the hypervisors."
  type        = map(string)
  default = {
    "debian_11" = "http://cloud.debian.org/images/cloud/bullseye/20220711-1073/debian-11-genericcloud-amd64-20220711-1073.qcow2",
    
  }
}

variable "os_image_format" {
  description = "The format used by the images."
  type        = string
  default     = "qcow2"
}