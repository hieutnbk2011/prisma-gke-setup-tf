# Define Terraform backend using a Google Cloud Storage bucket for storing the Terraform state
terraform {
  backend "gcs" {
    bucket  = "tfst-bucket"
    prefix    = "tfst-bucket/tfst-bucket"
    credentials = "C:/Users/User/Desktop/gke-private/sa.json" 
 }
}