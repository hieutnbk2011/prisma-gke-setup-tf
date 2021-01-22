# Google provider
provider "google" {
  credentials        = file("/root/.jenkins/terraform")
  project            = var.project
  region             = var.region
}