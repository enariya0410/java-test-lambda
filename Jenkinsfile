pipeline {
  agent any

  stages {
    stage('Build') {
      steps {
        // Checkout source code from version control (e.g., Git)
        checkout scm
        
        // Build the Java application
        sh 'mvn clean package'
      }
    }
    
    stage('Deploy to Azure') {
      environment {
        AZURE_CREDENTIALS = credentials('hahaha')
        AZURE_APP_NAME = 'java-env-Dev'
        AZURE_RESOURCE_GROUP = 'azureJenkinsJava'
      }
      
      steps {
        // Install Azure CLI on Jenkins agent
        sh 'curl -sL https://aka.ms/InstallAzureCLIDeb --output azure-cli.sh'
        sh 'bash azure-cli.sh --prefix ~/.azure-cli --install'


        // Authenticate with Azure using service principal credentials
        withCredentials([azureServicePrincipal(credentialsId: 'hahaha', variable: 'AZURE_CREDENTIALS')]) {
          sh 'az login --service-principal -u $AZURE_CREDENTIALS_USR -p $AZURE_CREDENTIALS_PSW --tenant $AZURE_CREDENTIALS_TENANT'
        }
        
        // Deploy the application to Azure App Services
        sh 'az webapp deployment source config-zip --src target/sample-1.0.3.jar --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_APP_NAME'
      }
    }
  }
}
