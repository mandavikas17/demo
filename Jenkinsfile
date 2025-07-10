pipeline {
    agent any

    environment {
        // Define your Docker Hub username and image name
        DOCKERHUB_USERNAME = 'mandavikas17'
        IMAGE_NAME = 'server-app'
        // This will create a tag like 'your-dockerhub-username/server-app:1.0.0' or 'your-dockerhub-username/server-app:latest'
        // For production, consider using Git commit SHA or semantic versioning for tags
        IMAGE_TAG = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${env.BUILD_NUMBER}"
        LATEST_IMAGE_TAG = "${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest"
    }

    stages {
        stage("git clone") {
            steps {
                script {
                    // Ensure the workspace is clean before cloning
                    cleanWs()
                    git branch: 'master', url: 'https://github.com/mandavikas17/demo.git'
                }
            }
        }
        stage ("building artifacts"){
            steps {
                sh "mvn clean install"
            }
        }
        stage("sonarqube coverage") {
            steps{
                withSonarQubeEnv('mysonar'){
                    dir("./server"){
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }
        stage ("quality gate"){
            steps{
                script{
                    // Wait for the SonarQube quality gate to be evaluated
                    // The waitForQualityGate() function returns a result object
                    def check = waitForQualityGate()

                    // Check the status of the quality gate.
                    // 'OK' means it passed, anything else means it failed (e.g., 'ERROR', 'WARN')
                    if (check.status != 'OK') {
                        error "Pipeline aborted due to SonarQube quality gate failed: ${check.status}"
                    } else {
                        echo "SonarQube Quality Gate passed: ${check.status}"
                    }
                }
            }
        }
        stage ("Pushing Artifacts to Artifactory") {
            steps {
                script {
                    rtServer(
                        id: 'jfrog',
                        url: 'http://54.164.104.105:8082/artifactory',
                        credentialsId: 'artifactory-jfrog-credentials'
                    )
                    rtUpload(
                        serverId: 'jfrog',
                        spec: '''{
                            "files": [
                                {
                                    "pattern": "./webapp/target/*.war",
                                    "target": "vikas/"
                                }
                            ]
                        }'''
                    )
                }
            }
        }
        stage("Docker Build") {
            steps {
                script {
                    // Navigate to the directory containing your Dockerfile
                    // Assuming Dockerfile is in the root of the cloned repo
                    // If it's in a subdirectory, e.g., 'server/', use: dir('server') { sh "docker build ..." }
                    sh "docker build -t ${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_TAG} ${LATEST_IMAGE_TAG}" // Also tag with 'latest'
                }
            }
        }
        stage("Docker Image Scan") {
            steps {
                script {
                    echo "Scanning Docker image: ${IMAGE_TAG}"
                    // Trivy command to scan the image
                    // --severity HIGH,CRITICAL: Only report High and Critical vulnerabilities.
                    // --exit-code 1: Exit with code 1 if any vulnerabilities of specified severity are found.
                    // This will fail the Jenkins stage if High/Critical vulnerabilities are detected.
                    // --format table: Output in a human-readable table format.
                    sh "trivy image --severity HIGH,CRITICAL --exit-code 1 --format table ${IMAGE_TAG}"

                    // Alternatively, to just report without failing the build, remove --exit-code 1
                    // sh "trivy image --severity HIGH,CRITICAL --format table ${IMAGE_TAG}"

                    // To scan for all severities:
                    // sh "trivy image --exit-code 1 --format table ${IMAGE_TAG}"
                }
            }
        }
        stage("Docker Push to Docker Hub") {
            steps {
                script {
                    // Use withCredentials to securely inject Docker Hub credentials
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                        sh "docker push ${IMAGE_TAG}"
                        sh "docker push ${LATEST_IMAGE_TAG}"
                    }
                }
            }
        }
    }
}
