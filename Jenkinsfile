pipeline {
    parameters {
        choice(
            name: 'ACTION',
            choices: ['apply', 'destroy'],
            description: 'Select the action you want to perform'
        )
    }
    agent any
    tools {
        terraform "terraform"
    }
    environment {
        ARM_ACCESS_KEY = credentials('ARM_ACCESS_KEY')
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'GitHubcredentials', url: 'https://github.com/Selmouni-Abdelilah/Terragrunt_Jenkins.git ']])
                }
            }
        }
        stage('Azure login'){
            steps{
                withCredentials([azureServicePrincipal('Azure_credentials')]) {
                    sh 'az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET -t $AZURE_TENANT_ID'
                }
            }
        }
        stage('Tflint Testing') {
            steps {
                script {
                    dir('Terragrunt/modules') {
                    sh ' curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash '
                    sh ' tflint --module --recursive '
                    }
                }
            }    
        }
        stage('Tfsec Testing') {
            steps {
                script {
                    dir('Terragrunt/modules') {
                    sh ' curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash '
                    sh ' tfsec -s'
                    }
                }
            }    
        }
        stage('Dev Environment') {
            steps {
                script {
                    dir('Terragrunt/Terragrunt_files/dev') {
                    sh "terragrunt run-all  ${params.ACTION}"
                    }
                }
            }    
        }
        stage('PreProd Environment') {
            steps {
                script {
                    dir('Terragrunt/Terragrunt_files/dev') {
                    sh "terragrunt run-all  ${params.ACTION}"
                    }
                }
            }    
        }
        stage('Prod Environment') {
            steps {
                script {
                    dir('Terragrunt/Terragrunt_files/dev') {
                    sh "terragrunt run-all  ${params.ACTION}"
                    }
                }
            }    
        }

    }
}