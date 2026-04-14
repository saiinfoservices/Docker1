pipeline {
    agent {
        docker {
            image 'salesforce/cli:2.57.7-slim'
            args '-u root'
        }
    }

    stages {
        stage('JWT Auth + Validate') {
            steps {
                sh '''
                    echo "Authenticating with JWT..."

                    sf org login jwt \
                      --client-id 3MVG9WVXk15qiz1K3Y5R4DxeUnb6CffFsw3P4BalbXFFkJee78lnpHbRi4xMWnoCte4BGX9_ggFfhxXMjBtd5 \
                      --jwt-key-file server.key \
                      --username your-username@example.com \
                      --alias TestOrg

                    echo "Running validation..."

                    sf project deploy validate \
                      --manifest package.xml \
                      --target-org TestOrg
                '''
            }
        }
    }
}
