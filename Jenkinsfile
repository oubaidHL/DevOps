pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'app-front'
        DOCKER_IMAGE_VERSION = '1.0.0'
        NVM_DIR = "${WORKSPACE}/.nvm"  // Define the NVM_DIR path in the workspace
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
                    // Install nvm if not already installed
                    sh 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash'
                    sh "export NVM_DIR=${NVM_DIR}"  // Set the NVM_DIR environment variable
                    sh "source ${NVM_DIR}/nvm.sh"   // Load nvm
                    sh 'nvm install 20.5.0'         // Install the desired Node.js version
                    sh 'nvm use 20.5.0'             // Use the desired Node.js version

                    // Set the full paths for ng, npm, and nvm
                    def nodeBin = "${NVM_DIR}/versions/node/v20.5.0/bin/"
                    def npmBin = "${NVM_DIR}/versions/node/v20.5.0/bin/"
                    def nvmBin = "${NVM_DIR}/nvm.sh"

                    // Add the full paths to the PATH variable
                    env.PATH = "${nodeBin}:${npmBin}:${env.PATH}"

                    // Verify that the PATH variable is correctly set
                    sh 'echo $PATH'

                    // Install Angular CLI using the installed Node.js version
                    sh "source ${nvmBin}"  // Load nvm (again)
                    sh 'npm install -g @angular/cli'
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Verify that the PATH variable still contains the full paths
                    sh 'echo $PATH'

                    // Run npm install to install project dependencies
                    sh 'npm install'

                    // Run ng build
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
