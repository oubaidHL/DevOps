pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Node.js') {
            steps {
                script {
                    // Install Node.js using the Tool Installer plugin
                    def nodejsHome = tool name: 'NodeJS-14', type: 'Tool'
                    env.PATH = "${nodejsHome}/bin:${env.PATH}"
                }
            }
        }

        stage('Install Angular CLI') {
            steps {
                sh 'npm install -g @angular/cli@12.0.5'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'npm install'  // Install project-specific npm dependencies
            }
        }

        stage('Check Schema') {
            steps {
                sh 'npm run schema:check'  // Adjust this command as per your project's requirements
            }
        }

        stage('Build') {
            steps {
                sh 'ng build'  // Build your Angular application
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
