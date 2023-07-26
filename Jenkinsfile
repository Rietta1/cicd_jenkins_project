@Library('jenkins_shared_lib') _

pipeline{

    agent any

    parameters{

        choice(name: 'action', choices: 'create\ndelete', description: 'Choose create/Destroy')

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
          agent {
                docker { image 'maven:3.8.3-adoptopenjdk-8' }
            }
            steps{
               script{
                   
                   mvnTest()
               }
            }
        }





    }

    
}

