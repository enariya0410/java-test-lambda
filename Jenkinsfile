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
        // Authenticate with Azure using service principal credentials
        withCredentials([azureServicePrincipal(credentialsId: 'hahaha', variable: 'AZURE_CREDENTIALS')]) {
          sh 'az login --service-principal -u $AZURE_CREDENTIALS_USR -p $AZURE_CREDENTIALS_PSW --tenant $AZURE_CREDENTIALS_TENANT'
          sh 'az login --service-principal -u <8d9a265d-8d8d-4403-99e9-178c9b64ad42> -p <1vP8Q~5gcvKLK_D7.O6BZytaLwXiTBx18Bqtabz.> --tenant <22aa5408-b583-4ea1-95a4-e2f6414c4cf9>'
        }
        
        // Deploy the application to Azure App Services
        sh 'az webapp deployment source config-zip --src target/sample-1.0.3.jar --resource-group $AZURE_RESOURCE_GROUP --name $AZURE_APP_NAME'
      }
    }
  }
}
