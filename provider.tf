# Google provider
provider "google" {
  credentials        = file("./sa.json")
  project            = var.project
  region             = var.region
}