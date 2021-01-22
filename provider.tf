# Google provider
provider "google" {
  credentials        = file("/root/.jenkins/terraform/sa.json")
  project            = var.project
  region             = var.region
}