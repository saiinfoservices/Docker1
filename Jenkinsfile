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
                withCredentials([
                    file(credentialsId: 'daf749e2-30e8-47e3-a05e-bf783b15bf17', variable: 'JWT_KEY')
                ]) {
                    sh '''
                        echo "JWT key path: $JWT_KEY"

                        sf org login jwt \
                          --client-id 3MVG9WVXk15qiz1K3Y5R4DxeUnb6CffFsw3P4BalbXFFkJee78lnpHbRi4xMWnoCte4BGX9_ggFfhxXMjBtd5 \
                          --jwt-key-file $JWT_KEY \
                          --username saikrishna.e06d4503945f@agentforce.com \
                          --instance-url https://login.salesforce.com \
                          --alias TestOrg

                        sf project deploy validate \
                          --manifest package.xml \
                          --target-org TestOrg
                    '''
                }
            }
        }
    }
}
