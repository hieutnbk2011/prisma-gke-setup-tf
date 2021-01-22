# Values for the google kubernetes

# Global values
name = "spinnaker-cd"
project = "telcom-team"
location = "us-central1-a"
region = "us-central1"
# ---------------------
# Existing network and subnetwork
network = "vpc-telco"
subnetwork = "telcosub-01"
# -------------------------

# Cluster values
master_version = "1.16.15-gke.4901"
node_version = "1.16.15-gke.4901"
initial_node_count = 1
default_max_pods_per_node = 8
max_node_count = 2
min_node_count = 1
machine_type = "n1-standard-4"
image_type = "COS"
disk_type = "pd-standard"
disk_size_gb = "50"
node_locations = ["us-central1-a"]
oauth_scopes = ["https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring"]
istio     = false
istio_auth     = "AUTH_MUTUAL_TLS"
authenticator_security_group     = "gke-security-groups@cloudplaybookio-gcp.com"
enable_shielded_nodes     = true
enable_vertical_pod_autoscaling     = true
enable_legacy_abac = true
# enable_network_egress_export     = false
# enable_resource_consumption_export     = true
enable_private_endpoint     = false
enable_private_nodes     = true
master_ipv4_cidr_block     = "10.1.0.0/28"
master_authorized_networks     = []
# --------------------------------

# Logging and monitoring
logging_service     = "logging.googleapis.com/kubernetes"
monitoring_service     = "monitoring.googleapis.com/kubernetes"
#-----------------------

# Labels and tags
labels = {
        "cloud"   = "gcp"
        "cluster"  = "gke"
        "region"  = "us-central1"
    }
tags = ["allow-ping", "allow-public"]
# -----------------------------