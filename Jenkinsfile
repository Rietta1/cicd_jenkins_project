@Library('jenkins_shared_lib') _

pipeline{

    agent any

    parameters{

        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')
        string(name: 'ImageName', description: "name of the docker build", defaultValue: 'javapp')
        string(name: 'ImageTag', description: "tag of the docker build", defaultValue: 'v1')
        string(name: 'DockerHubUser', description: "name of the Application", defaultValue: 'rietta')
    }
    environment{

        DOCKER_HUB_KEY = credentials('docker')
      
    }

    stages{

        stage('Git Checkout'){
        when { expression {  params.action == 'create' } }
            steps{
            gitCheckout(
                branch: "main",
                url: "https://github.com/Rietta1/java_app.git"
               )
             }

        }
        stage('Unit Test maven'){
        when { expression {  params.action == 'create' } }
            steps{
               script{
                   
                   mvnTest()
               }
            }
        }
        stage('Integration Test maven'){
         when { expression {  params.action == 'create' } }

            steps{
               script{
                   
                   mvnIntegrationTest()
               }
            }
     
        }
        stage('Static code analysis: Sonarqube'){
         when { expression {  params.action == 'create' } }
                    
            steps{
               script{
                   
                   def SonarQubecredentialsId = 'sonarqube-api'
                   statiCodeAnalysis(SonarQubecredentialsId)
               }
            }
        }
        stage('Quality Gate Status Check : Sonarqube'){
         when { expression {  params.action == 'create' } }
       
            steps{
               script{
                   
                   def SonarQubecredentialsId = 'sonarqube-api'
                   QualityGateStatus(SonarQubecredentialsId)
               }
            }
        }
        stage('Maven Build : maven'){
         when { expression {  params.action == 'create' } }

            steps{
               script{
                   
                   mvnBuild()
               }
            }
        }
        stage('Docker Image Build'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                    // Change the context to the correct directory
                    dir("/var/lib/jenkins/workspace/java_app@2/") {                   
                     dockerBuild("${params.ImageName}","${params.ImageTag}","${params.DockerHubUser}")
                    }
               }
            }
        }





    }

    
}

