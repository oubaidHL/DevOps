pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = 'app-front'
        DOCKER_IMAGE_VERSION = '1.0.0'
        NVM_DIR = "$HOME/.nvm"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Set Node.js Version') {
            steps {
                script {
                    def nodeVersion = '20.5.0'
                    sh "nvm use ${nodeVersion}"
                }
            }
        }

        stage('Set Angular CLI Version') {
            steps {
                script {
                    def ngBin = '/var/lib/jenkins/.nvm/versions/node/v20.5.0/bin/ng'
                    env.PATH = "${ngBin}:${env.PATH}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
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
