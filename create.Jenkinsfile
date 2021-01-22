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


        KUBECTL_VERSION         = envfiles('KUBECTL_VERSION')
    }

    stages {
        stage('Clean Workspace') {
            steps {
                sh "git clean -xdff"
            }
        }

        stage('Terraform Cluster') {

            steps {
                dir('cluster') {
				    sh "pwd"
					sh "ls -lrta"
                    sh "terraform init -no-color"
                    sh "terraform workspace select -no-color ${TERRAFORM_WORKSPACE} || terraform workspace new -no-color ${TERRAFORM_WORKSPACE}"
                    sh "terraform refresh -no-color"
					sh "terraform apply -var-file=terraform.tfvars"
                }
            }
        }


    }
}
