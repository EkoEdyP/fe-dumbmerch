pipeline {
    agent any

    environment {
        IMAGE_NAME = "fe-dumbmerch"
        CONTAINER_NAME = "fe-dumbmerch-app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/EkoEdyP/fe-dumbmerch.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:latest ."
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    // Hentikan dan hapus container lama jika sudah berjalan
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    
                    // Jalankan container baru di port 3000
                    sh "docker run -d --name ${CONTAINER_NAME} -p 3000:80 ${IMAGE_NAME}:latest"
                }
            }
        }
    }

    post {
        success {
            echo "Deploy berhasil! Aplikasi berjalan di http://localhost:3000"
        }
        failure {
            echo "Pipeline gagal. Periksa Console Output untuk detail error."
        }
    }
}