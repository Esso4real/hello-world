pipeline {
    agent any
    
    maven "maven"

    stages {
        stage('Build Jar') {
            steps {
                script {
                    echo "Building the jar file"
                    sh "mvn -f pom.xml clean package"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building docker image from jar file"
                    withCredentials([usernamePassword(credentialsId: 'hub-docker', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                            sh "docker build -t esso4real/myhtmlapp:tek-v1.0 ."
                            sh "echo $PASS | docker login -u $USER --password-stdin"
                            sh "docker push esso4real/myhtmlapp:tek-v1.0"
                        }
                    
                }
            }
        }
        stage('Deploying App') {
            steps {
                script {
                    echo "Deploying the App"
                    sshagent(['Jenkins-hub']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@3.92.186.61"
                        withCredentials([usernamePassword(credentialsId: 'hub-docker', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                            sh "sudo apt install docker.io"
                            sh "sudo systemctl start docker"
                            sh "echo $PASS | docker login -u $USER --password-stdin"
                            sh "docker run -d -p 8080:8080 esso4real/myhtmlapp:tek-v1.0"
                        
                        }
                    }
                }
            }
        }
    }
}
