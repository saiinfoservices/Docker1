pipeline {
    agent {
        docker {
            image 'salesforce/cli:2.57.7-slim'
            args '-u root'
        }
    }

    options {
        timestamps()
    }

    stages {

        // -------------------------------
        // Stage 1: Authorize Salesforce Org
        // -------------------------------
        stage('Authorize Salesforce Org') {
            steps {
                withCredentials([
                    string(credentialsId: 'Consumer_Key', variable: 'SF_CLIENT_ID'),
                    string(credentialsId: 'SFUsername', variable: 'SF_USERNAME'),
                    file(credentialsId: 'daf749e2-30e8-47e3-a05e-bf783b15bf17', variable: 'JWT_KEY')
                ]) {
                    sh '''
                        echo "Authenticating with JWT..."

                        sf org login jwt \
                          --client-id $SF_CLIENT_ID \
                          --jwt-key-file $JWT_KEY \
                          --username $SF_USERNAME \
                          --instance-url https://login.salesforce.com \
                          --alias TestOrg
                    '''
                }
            }
        }

        // -------------------------------
        // Stage 2: Run PMD Analysis
        // -------------------------------
        stage('Run PMD Analysis') {
            steps {
                sh '''
                    echo "Installing PMD..."

                    apt-get update && apt-get install -y wget unzip

                    wget -q https://github.com/pmd/pmd/releases/download/pmd_releases/7.0.0/pmd-bin-7.0.0.zip
                    unzip -q pmd-bin-7.0.0.zip

                    echo "Running PMD scan..."

                    ./pmd-bin-7.0.0/bin/pmd check \
                      -d force-app \
                      -R category/apex/design.xml \
                      -f html \
                      -r pmd-report.html || true
                '''
            }
        }
    }

    // -------------------------------
    // Post: Publish HTML Report
    // -------------------------------
    post {
        always {
            echo "Publishing PMD HTML report..."

            publishHTML([
                reportDir: '.',
                reportFiles: 'pmd-report.html',
                reportName: 'PMD Code Analysis Report',
                keepAll: true,
                alwaysLinkToLastBuild: true,
                allowMissing: true
            ])
        }

        success {
            echo "✅ Pipeline completed successfully"
        }

        failure {
            echo "❌ Pipeline failed"
        }
    }
}
