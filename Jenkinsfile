pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'app-front'
        DOCKER_IMAGE_VERSION = '1.0.0'
        NVM_DIR = "${WORKSPACE}/.nvm"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Prepare Environment') {
    steps {
        script {
            // Create the .nvm directory in the workspace
            sh "mkdir -p ${NVM_DIR}"

            // Install nvm if not already installed
            sh 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash'
            
            // Load nvm by sourcing the nvm.sh script
            sh 'export NVM_DIR="$WORKSPACE/.nvm"'
            sh '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"'

            // Install Node.js 20.5.0
            sh 'nvm install 20.5.0'
            sh 'nvm use 20.5.0'

            // Set the full paths for ng, npm, and nvm
            def nodeBin = "${NVM_DIR}/versions/node/v20.5.0/bin/"
            def npmBin = "${NVM_DIR}/versions/node/v20.5.0/bin/"

            env.PATH = "${nodeBin}:${npmBin}:${env.PATH}"

            // Verify that the PATH variable is correctly set
            sh 'echo $PATH'

            // Install Angular CLI using the installed Node.js version
            sh 'npm install -g @angular/cli'
        }
    }
}

        stage('Build') {
            steps {
                script {
                    sh 'echo $PATH'
                    sh 'npm install'
                    sh 'ng build'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    sh "docker login -u \$DOCKER_HUB_USERNAME -p \$DOCKER_HUB_PASSWORD"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} oubaidhl/devops:${DOCKER_IMAGE_VERSION}"
                    sh "docker push \$DOCKER_HUB_USERNAME/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"
                }
            }
        }

        stage('Remove Docker Compose Containers') {
            steps {
                sh 'docker-compose down'
            }
        }

        stage('Start Docker Compose') {
            steps {
                sh 'docker-compose up -d'
            }
        }
    }
}
