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
        // Stage 2: Install Code Analyzer
        // -------------------------------
        stage('Install Code Analyzer') {
            steps {
                sh '''
                    echo "Installing Salesforce Code Analyzer..."
                    sf plugins install @salesforce/sfdx-scanner
                '''
            }
        }

        // -------------------------------
        // Stage 3: Run Code Analysis (HTML)
        // -------------------------------
        stage('Run Code Analysis (HTML Output)') {
            steps {
                sh '''
                    set +e

                    echo "Running scanner with HTML output..."

                    sf scanner run \
                      --engine pmd \
                      --target Temptest.cls \
                      --format html \
                      --outfile pmd-report.html

                    echo "Generated files:"
                    ls -l

                    echo "Preview (first lines of HTML):"
                    head -20 pmd-report.html || echo "HTML not generated"
                '''
            }
        }
    }

    // -------------------------------
    // Post Actions
    // -------------------------------
    post {
        always {
            echo "Archiving HTML report..."

            archiveArtifacts artifacts: 'pmd-report.html', allowEmptyArchive: true
        }

        success {
            echo "✅ Pipeline completed successfully"
        }

        failure {
            echo "❌ Pipeline failed"
        }
    }
}
