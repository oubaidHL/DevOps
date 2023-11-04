pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    # Verify npm and ng versions
                    /var/lib/jenkins/.nvm/versions/node/v20.5.0/bin/npm -v
                    /var/lib/jenkins/.nvm/versions/node/v20.5.0/bin/ng --version

                    # Install project dependencies
                    /var/lib/jenkins/.nvm/versions/node/v20.5.0/bin/npm install

                    # Build your Angular project
                    /var/lib/jenkins/.nvm/versions/node/v20.5.0/bin/ng build
                '''
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
