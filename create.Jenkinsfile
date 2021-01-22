def envfiles(String env_name) {
    def result = readProperties file: '.env'
    return result[env_name]
}


pipeline {
    agent any

    stages {
        stage('Clean Workspace') {
            steps {
                sh "git clean -xdff"
            }
        }

        stage('Terraform Cluster') {

            steps {
				    sh "pwd"
					sh "whoami"
                    sh "terraform init -no-color"
                    sh "terraform workspace select -no-color ${TERRAFORM_WORKSPACE} || terraform workspace new -no-color ${TERRAFORM_WORKSPACE}"
                    sh "terraform refresh -no-color"
					sh "terraform apply -var-file=terraform.tfvars"
            }
        }


    }
}
