pipeline {
    agent {
        docker {
            image 'salesforce/cli:latest-slim'
        }
    }

    stages {
        stage('PR Validation') {
            steps {
                sh "sf update"
            }
        }
    }
}
