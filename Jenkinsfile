pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                    npm install --global@20.5.0 npm
                    npm install --global@12.0.1 @angular/cli
                '''
            }
        }

        stage('Build') {
            steps {
                sh '''
                    # Verify npm and ng versions
                    npm -v
                    ng --version

                    # Install project dependencies
                    npm install

                    # Build your Angular project
                    ng build
                '''
            }
        }
