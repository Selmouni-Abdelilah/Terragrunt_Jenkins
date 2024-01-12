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
        stage("Generate Documentation") {
            steps {
                sh "terraform-docs markdown . --recursive --output-file README.md"
                sh "git add modules"
                sh "git commit -m 'Add terraform documentation from Jenkins'"
            }
        }
        stage("Push to Git Repository") {
            steps {
                withCredentials([gitUsernamePassword(credentialsId: 'GitHubcredentials', gitToolName: 'Default')]) {
                    sh "git branch -m main"
                    sh "git push -u origin main"
                }
            }
        }
        stage('Tflint Testing') {
            steps {
                script {
                    sh ' sudo curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash '
                    dir('modules') {
                        sh ' tflint --init --recursive'
                        sh ' tflint --module --recursive --force '
                    }
                }
            }    
        }
        stage('Tfsec Testing') {
            steps {
                script {
                    sh ' sudo curl -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh | bash '
                    dir('modules') {
                        sh ' tfsec -s'
                    }
                }
            }    
        }
        stage('Dev Environment') {
            steps {
                script {
                    dir('Terragrunt_files/dev') {
                        sh 'terragrunt run-all  init'
                        sh "terragrunt run-all  ${params.ACTION} --terragrunt-non-interactive -lock=false"
                    }
                }
            }    
        }
        stage('PreProd Environment') {
            steps {
                script {
                    dir('Terragrunt_files/preprod') {
                        sh 'terragrunt run-all  init'
                        sh "terragrunt run-all  ${params.ACTION} --terragrunt-non-interactive -lock=false"
                    }
                }
            }    
        }
        stage('Prod Environment') {
            steps {
                script {
                    dir('Terragrunt_files/prod') {
                        sh 'terragrunt run-all  init'
                        sh "terragrunt run-all  ${params.ACTION} --terragrunt-non-interactive -lock=false"
                    }
                }
            }    
        }

    }
}
