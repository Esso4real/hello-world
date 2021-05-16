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
        
        
        stage('DeployToStaging') {
            when {
                branch 'master'
            }
            steps {
                deploy adapters: [tomcat8(credentialsId: 'tomcat', path: '', url: 'http://54.245.201.199:8080/')], contextPath: '/', war: '**/*.war'
            }
        }
        
    }
}
