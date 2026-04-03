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
                sh '''
                    echo "PR ID        : $CHANGE_ID"
                    echo "Source branch: $CHANGE_BRANCH"
                    echo "Target branch: $CHANGE_TARGET"
                    sf --version
                    sf update
                    echo "hello sai"
                '''
            }
        }
    }
}
