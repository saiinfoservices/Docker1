pipeline {
    agent {
        docker {
            image 'salesforce/cli:latest-slim'
        }
    }

    stages {
        stage('PR Validation') {
            when {
                changeRequest()
            }
            steps {
                sh "sf update"
            }
        }
    }
}
