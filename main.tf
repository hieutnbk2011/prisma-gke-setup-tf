
# Existing google project
data "google_project" "project" {
  project_id = var.project
}

locals {
  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]
}

# Creating the kubernetes cluster
resource "google_container_cluster" "primary" {
  provider                  = google-beta
  project                   = var.project
  name                      = var.name
  location                  = var.location
  network                   = var.network
  subnetwork                = var.subnetwork
  node_locations            = var.node_locations
  default_max_pods_per_node = var.default_max_pods_per_node
  min_master_version        = var.master_version
  node_version              = var.node_version
  logging_service           = var.logging_service
  monitoring_service        = var.monitoring_service
  enable_legacy_abac        = var.enable_legacy_abac
  enable_shielded_nodes     = var.enable_shielded_nodes
  #   authenticator_security_group = var.authenticator_security_group

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  # resource_usage_export_config {
  #   enable_network_egress_metering       = var.enable_network_egress_export
  #   enable_resource_consumption_metering = var.enable_resource_consumption_export

  #   bigquery_destination {
  #     dataset_id = "gkedtset"
  #   }
  # }

  workload_identity_config {
    identity_namespace = "${data.google_project.project.project_id}.svc.id.goog"
  }

  authenticator_groups_config {
    security_group = var.authenticator_security_group
  }

  resource_labels = {
    cloud   = var.labels["cloud"]
    cluster = var.labels["cluster"]
    region  = var.labels["region"]
  }
  network_policy {
    enabled = true
  }
  addons_config {
    istio_config {
      disabled = ! var.istio
      auth     = var.istio_auth
    }

    cloudrun_config {
      disabled = true
    }

    horizontal_pod_autoscaling {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }

    network_policy_config {
      disabled = true
    }
  }
  cluster_autoscaling {
    enabled = true

    resource_limits {
      maximum       = 2
      minimum       = 1
      resource_type = "memory"
    }
    resource_limits {
      maximum       = 2
      minimum       = 1
      resource_type = "cpu"
    }
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  private_cluster_config {
    enable_private_nodes    = var.enable_private_nodes
    enable_private_endpoint = var.enable_private_endpoint
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  node_pool {
    initial_node_count = var.initial_node_count
    node_config {
      oauth_scopes = var.oauth_scopes
      machine_type = var.machine_type
      image_type   = var.image_type
      disk_type    = var.disk_type
      disk_size_gb = var.disk_size_gb

      metadata = {
        disable-legacy-endpoints = "true"
      }

      labels = {
        cloud   = var.labels["cloud"]
        cluster = var.labels["cluster"]
        region  = var.labels["region"]
      }

      tags = var.tags
    }
    autoscaling {
      max_node_count = var.max_node_count
      min_node_count = var.min_node_count
    }

  }

}


