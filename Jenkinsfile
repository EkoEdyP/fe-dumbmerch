pipeline {
    agent any

    environment {
        IMAGE_NAME = "fe-dumbmerch"
        CONTAINER_NAME = "fe-dumbmerch-app"
        // Sesuaikan dengan nama kredensial token SonarQube di Jenkins Anda
        SONAR_CREDENTIALS_ID = "squ_37252768fff59a33b775e0dd3ae7ed517b993249" 
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'test', url: 'https://github.com/EkoEdyP/fe-dumbmerch.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    // Pastikan nama server SonarQube di Manage Jenkins -> System sesuai (misal: SonarQube-Local)
                    withSonarQubeEnv('SonarQube-Local') {
                        sh "sonar-scanner -Dsonar.projectKey=fe-dumbmerch -Dsonar.sources=src"
                    }
                }
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
                    // Hentikan dan hapus container lama jika sedang berjalan
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
            echo "Pipeline CI/CD dan SonarQube berhasil! Aplikasi berjalan di http://localhost:3000"
        }
        failure {
            echo "Pipeline gagal. Periksa Console Output untuk detail error."
        }
    }
}