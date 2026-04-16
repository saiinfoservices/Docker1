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
                sh 'sf plugins install @salesforce/sfdx-scanner'
            }
        }

        // -------------------------------
        // Stage 3: Extract Apex Classes
        // -------------------------------
        stage('Extract Apex Classes') {
            steps {
                sh '''
                    echo "Extracting Apex classes from package.xml..."

                    apt-get update && apt-get install -y libxml2-utils

                    # Extract only ApexClass members
                    xmllint --xpath "//types[name='ApexClass']/members/text()" package.xml 2>/dev/null > raw.txt || true

                    echo "Raw members:"
                    cat raw.txt

                    # Convert space-separated → newline → add .cls
                    tr ' ' '\\n' < raw.txt | sed '/^$/d' | sed 's/$/.cls/' > class-files.txt

                    echo "Final class files:"
                    cat class-files.txt
                '''
            }
        }

        // -------------------------------
        // Stage 4: Run PMD (Filtered)
        // -------------------------------
        stage('Run Code Analysis (Filtered)') {
            steps {
                sh '''
                    set +e

                    if [ ! -s class-files.txt ]; then
                        echo "No Apex classes found in package.xml. Skipping scan."
                        exit 0
                    fi

                    FILES=$(paste -sd "," class-files.txt)

                    echo "Files to scan:"
                    echo $FILES

                    sf scanner run \
                      --engine pmd \
                      --target "$FILES" \
                      --format table

                    echo "Scan completed"
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully"
        }
        failure {
            echo "❌ Pipeline failed"
        }
    }
}
