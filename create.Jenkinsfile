def envfiles(String env_name) {
    def result = readProperties file: '.env'
    return result[env_name]
}


pipeline {
    agent {
        docker {
            image 'hashicorp/terraform:0.12.19'
            args  '--entrypoint=""'
        }
    }

    environment {
        HOME                    = "${WORKSPACE}"

        TERRAFORM_WORKSPACE     = envfiles('TERRAFORM_WORKSPACE')
        TERRAFORM_DEPLOY_HELM   = envfiles('TERRAFORM_DEPLOY_HELM')

        ARM_CLIENT_ID           = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET       = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID     = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID           = credentials('ARM_TENANT_ID')

        KUBECTL_VERSION         = envfiles('KUBECTL_VERSION')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                sh "git clean -xdff"
            }
        }

        stage('Terraform Cluster') {
            environment {
                ARM_ACCESS_KEY                   = credentials('ARM_ACCESS_KEY')

                TF_VAR_aks_sp_id                 = credentials('ARM_CLIENT_ID')
                TF_VAR_aks_sp_secret             = credentials('ARM_CLIENT_SECRET')

                TF_VAR_aks_aad_client_app_id     = credentials('AAD_CLIENT_APP_ID')
                TF_VAR_aks_aad_server_app_id     = credentials('AAD_SERVER_APP_ID')
                TF_VAR_aks_aad_server_app_secret = credentials('AAD_SERVER_APP_SECRET')
            }

            steps {
                dir('cluster') {
				    sh "pwd"
					sh "ls -lrta"
#                    sh "terraform init -no-color"
#                    sh "terraform workspace select -no-color ${TERRAFORM_WORKSPACE} || terraform workspace new -no-color ${TERRAFORM_WORKSPACE}"
#                    sh "terraform refresh -no-color"
#                    sh "terraform plan -no-color -out terraform.plan"
#                    sh "terraform apply -no-color terraform.plan"
                }
            }
        }

        stage('Cluster Check') {
            steps {
                dir('cluster') {
#                    sh "mkdir -p ${HOME}/bin"
#                    sh "wget -O ${HOME}/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
#                    sh "chmod 0755 ${HOME}/bin/kubectl"
#                    sh "${HOME}/bin/kubectl --kubeconfig=kubeconfig_admin.yaml get node -o wide"
#                    sh "${HOME}/bin/kubectl --kubeconfig=kubeconfig_admin.yaml get all --all-namespaces"
                }
            }
        }

        stage('Terraform Helm') {
            when {
                expression { "${TERRAFORM_DEPLOY_HELM}".toBoolean() }
            }

            environment {
                TF_VAR_helm_home = "${WORKSPACE}/helm/.helm"
            }

            steps {
                dir('helm') {
                    sh "terraform init -no-color"
                    sh "terraform refresh -no-color"
                    sh "terraform plan -no-color -out terraform.plan"
#                    sh "terraform apply -no-color terraform.plan"
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'cluster/kubeconfig_*.yaml'
            }
        }
    }
}
