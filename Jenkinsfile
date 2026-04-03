pipeline {
    agent {
        docker {
            image 'salesforce/cli:latest-slim'
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    environment {
        // Default placeholders; will be set dynamically
        SF_USERNAME = ''
        SF_PASSWORD = ''
        SF_TOKEN    = ''
    }

    stages {

        // -------------------------------
        // Stage 1: Select Org Credentials
        // -------------------------------
        stage('Select Org Credentials') {
            steps {
                script {
                    def targetBranch = env.CHANGE_TARGET ?: env.BRANCH_NAME
                    echo "Target branch detected: ${targetBranch}"

                    switch (targetBranch) {
                        case 'qa':
                            env.SF_USERNAME = credentials('sf-qa-username')
                            env.SF_PASSWORD = credentials('sf-qa-password')
                            env.SF_TOKEN    = credentials('sf-qa-token')
                            echo "Using QA org"
                            break

                        case 'uat':
                            env.SF_USERNAME = credentials('sf-uat-username')
                            env.SF_PASSWORD = credentials('sf-uat-password')
                            env.SF_TOKEN    = credentials('sf-uat-token')
                            echo "Using UAT org"
                            break

                        case 'main':
                            env.SF_USERNAME = credentials('sf-prod-username')
                            env.SF_PASSWORD = credentials('sf-prod-password')
                            env.SF_TOKEN    = credentials('sf-prod-token')
                            echo "Using PROD org"
                            break

                        default:
                            error "Unsupported target branch: ${targetBranch}"
                    }
                }
            }
        }

        // -------------------------------
        // Stage 2: Authenticate Org
        // -------------------------------
        stage('Authenticate Org') {
            steps {
                sh """
                    sf org login username-password \
                      --username $SF_USERNAME \
                      --password $SF_PASSWORD \
                      --security-token $SF_TOKEN \
                      --alias TargetOrg
                """
            }
        }

        // -------------------------------
        // Stage 3: Capture Test Classes
        // -------------------------------
        stage('Capture Test Classes') {
            when { expression { return env.CHANGE_ID } } // Only for PR builds
            steps {
                script {
                    def testClasses = sh(
                        script: "xmllint --xpath \"//types[name='ApexClass']/members/text()\" package.xml 2>/dev/null || true",
                        returnStdout: true
                    ).trim()

                    if (testClasses) {
                        env.TEST_CLASSES = testClasses.replaceAll('\\s+', ',')
                        echo "Test classes found: ${env.TEST_CLASSES}"
                    } else {
                        env.TEST_CLASSES = ""
                        echo "No test classes found in package.xml"
                    }
                }
            }
        }

        // -------------------------------
        // Stage 4: PR Validation
        // -------------------------------
        stage('PR Validation') {
            when { expression { return env.CHANGE_ID } } // Only for PR builds
            steps {
                script {
                    if (env.TEST_CLASSES) {
                        sh "sf project deploy validate --tests ${env.TEST_CLASSES} --manifest package.xml --target-org TargetOrg"
                    } else {
                        sh "sf project deploy validate --manifest package.xml --target-org TargetOrg"
                    }
                }
            }
        }

        // -------------------------------
        // Stage 5: Deployment
        // -------------------------------
        stage('Deployment') {
            when { branch 'main' } // Only after merge into main
            steps {
                sh "sf project deploy start --manifest package.xml --target-org TargetOrg"
            }
        }
    }

    // -------------------------------
    // Post Actions
    // -------------------------------
    post {
        always {
            echo "Cleaning workspace..."
            cleanWs()
        }
        success {
            echo "✅ Pipeline completed successfully!"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}
