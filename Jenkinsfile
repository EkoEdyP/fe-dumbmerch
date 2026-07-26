pipeline {
    agent any

    tools {
        nodejs 'node16'
    }

    environment {
        AWS_REGION          = 'ap-southeast-1'
        ECR_REPO            = 'trysast/private-registry'
        ECR_REGISTRY        = "252303747004.dkr.ecr.${AWS_REGION}.amazonaws.com"
        IMAGE_TAG           = "${env.BUILD_NUMBER}"
        REACT_APP_BASEURL   = '<url-backend-be-dumbmerch>'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('SAST - SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh 'sonar-scanner'
                }
            }
        }
        stage('Quality Gate') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh """
                    docker build \
                      --build-arg REACT_APP_BASEURL=${REACT_APP_BASEURL} \
                      -t ${ECR_REPO}:${IMAGE_TAG} .
                """
            }
        }
        stage('Push to ECR') {
            steps {
                sh """
                    aws ecr get-login-password --region ${AWS_REGION} | \
                    docker login --username AWS --password-stdin ${ECR_REGISTRY}
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                    docker tag ${ECR_REPO}:${IMAGE_TAG} ${ECR_REGISTRY}/${ECR_REPO}:latest
                    docker push ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}
                    docker push ${ECR_REGISTRY}/${ECR_REPO}:latest
                """
            }
        }
    }
    post {
        failure {
            echo 'Pipeline gagal — cek stage SAST atau build.'
        }
        success {
            echo "Image berhasil dipush: ${ECR_REGISTRY}/${ECR_REPO}:${IMAGE_TAG}"
        }
    }
}
