# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 
## Loging and Monitoring for the Google Kubernetes
To enable logging and monitoring on gke add the following code on gke
```Terraform
  logging_service           = var.logging_service
  monitoring_service        = var.monitoring_service
```
You need also to activate the monitoring api on google cloud. To do that click Monitoring on resource listed on hamberger button. After that the deployment you will see the gke resource in monitoring dashboard.
## Enable Shielded Nodes
```Terraform
  enable_shielded_nodes     = var.enable_shielded_nodes
```
To enable the shielded node you just need to add the above code on the gke

# Add the metering 

To add metering you need to add the following code in gke template. 
In this code you need to reference a bigquery dataset. 
  resource_usage_export_config {
    enable_network_egress_metering       = var.enable_network_egress_export
    enable_resource_consumption_metering = var.enable_resource_consumption_export

    bigquery_destination {
      dataset_id = "gkedtset"
    }
  }
To create a bigquery dataset click on the humberger button and find bigquery. On the Data transfer tab click Create Transfer.Click on the Data set ID text box and you will see an option Create New Data Set. Click that and enter a name and that name must be referenced on `dataset_id` in `bigquery_destination` section  

# Security group
To add security group you need to add the following code and also you need to create this security group. 
```Terraform
authenticator_groups_config {
    security_group = var.authenticator_security_group
  }
  ```

  To create a security group go to the humberger button put the mouse on the IAM $ Member and click Goups. In this page you will see your domain name like `@cloudplaybookio-gcp.com`. Click the Select button aside the domain and after that click Create. Enter a name and on the group email add the `gke-security-goups`. After that add thi value to the variable associated with the security_group. 
# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)