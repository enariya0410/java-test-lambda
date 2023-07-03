pipeline {
    agent any

    environment {
        function_Dev = 'java-lambda-test_Dev'
        function_Test = 'java-lambda-test_Test'
        function_Prod = 'java-lambda-test_Prod'

    }

    parameters {
        string(name: 'RollbackVersion', description: 'Please enter rollback version')
        choice(
            choices: ['Dev', 'Test', 'Prod'],
            name: 'Environment',
            description : 'Please select environment'
        )
    }

    stages {
        // CI Start
        stage('Build') {
            steps {
                echo 'Build'
                sh 'mvn package'
            }
        }

        stage("SonarQube analysis") {
             agent any

             when {
                 anyOf {
                     branch 'feature/*'
                     branch 'main'
                 }
             }
             steps {
                 withSonarQubeEnv('Sonar') {
                     sh 'mvn sonar:sonar'
                 }
             }
        }

        stage('Push') {
            steps {
                echo 'Push'
                sh "aws s3 cp target/sample-1.0.3.jar s3://ektajavaartifacts"
            }
        }

        // Ci Ended

        // CD Started

        stage('Deployments') {
            parallel {

                stage('Deploy to Dev') {
                    steps {
                        echo 'Build'
                        sh "aws lambda update-function-code --function-name $function_Dev --region us-east-1 --s3-bucket ektajavaartifacts --s3-key sample-1.0.3.jar"
                    }
                }

                stage('Deploy to test ') {
                    steps {
                        echo 'Build'
                        sh "aws lambda update-function-code --function-name $function_Test --region us-east-1 --s3-bucket ektajavaartifacts --s3-key sample-1.0.3.jar"
                    }
                }
            }
        }

        stage('Deploy to Prod') {
            when {
                expression { return params.Environment == 'Prod'}
            }
            steps {
               input (
                    message: 'Would you like to proceed for Production Deployment?'
               )
            }
        }

        stage('Release to Prod') {
            when {
                branch 'main'
            }
            steps {
                sh "aws lambda update-function-code --function-name $function_Prod --region us-east-1 --s3-bucket ektajavaartifacts --s3-key sample-1.0.3.jar"
            }
        }
        // CD Ended
    }

    post {
        always {
            echo "${env.BUILD_ID}"
            echo "${BRANCH_NAME}"
            echo "${JENKINS_URL}"
            mail to: 'enariya0410@gmail.com', subject: 'Build status' ,body: 'this build is successful'
                

        }

        failure {
            echo 'failed'
        }
        aborted {
            echo 'aborted'
        }
    }
}
