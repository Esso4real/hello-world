pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh 'mvn -f pom.xml clean package'
 
                archiveArtifacts artifacts: '**/*.war', followSymlinks: false
            }
        }
        
        
        stage('Build Docker Image') {
           
            steps {
                sh "pwd"
                sh "ls -a"
                sh "docker build . -t tomcatsamplewapp:${env.BUILD_ID}"
            }
        }
    }    
}