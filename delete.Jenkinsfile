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

        ARM_CLIENT_ID           = credentials('ARM_CLIENT_ID')
        ARM_CLIENT_SECRET       = credentials('ARM_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID     = credentials('ARM_SUBSCRIPTION_ID')
        ARM_TENANT_ID           = credentials('ARM_TENANT_ID')
        ARM_ACCESS_KEY          = credentials('ARM_ACCESS_KEY')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                sh "git clean -xdff"
            }
        }

        stage('Terraform Init') {
            steps {
                dir('cluster') {
                    sh "terraform init -no-color"
                }
            }
        }

        stage('Terraform Plan') {
            environment {
                TF_VAR_client_id     = credentials('ARM_CLIENT_ID')
                TF_VAR_client_secret = credentials('ARM_CLIENT_SECRET')
            }

            steps {
                dir('cluster') {
                    sh "terraform workspace select -no-color ${TERRAFORM_WORKSPACE}"
                    sh "terraform refresh -no-color"
                    sh "terraform plan -no-color -destroy -input=false"
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                dir('cluster') {
                    sh "terraform destroy -no-color -auto-approve -input=false"
                }
            }
        }
    }
}
