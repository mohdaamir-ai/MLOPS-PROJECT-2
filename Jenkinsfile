pipeline{
    agent any

    environment {
        VENV_DIR = "venv"
        GCP_PROJECT = "project-5a246c4c-cd53-4d53-b12"
        GCLOUD_PATH = "/var/jenkins_home/google-cloud-sdk/bin"
    }

    stages{
        stage('Cloning Github repo to jenkins'){
            steps{
                script{
                    echo 'Cloning Github repo to jenkins.............'
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-token', url: 'https://github.com/mohdaamir-ai/MLOPS-PROJECT-2.git']])
                }
            }
        }

        stage('Setting up our Virtual Environment and installing dependencies'){
            steps{
                script{
                    echo 'Setting up our Virtual Environment and installing dependencies.............'
                    sh '''
                    python -m venv ${VENV_DIR}
                    . ${VENV_DIR}/bin/activate
                    pip install --upgrade pip
                    pip install -e .

                    '''
                }
            }
        }

        stage('Building and Pushing Docker Image to GCR...... '){
            steps{
                withCredentials([file(credentialsId: 'gcp-key' , variable : 'GOOGLE_APPLICATION_CREDENTIALS')]){
                    script{
                        echo 'Building and Pushing Docker Image to GCR......'
                        sh '''
                        export PATH=$PATH:${GCLOUD_PATH}

                        gcloud auth activate-service-account --key-file=${GOOGLE_APPLICATION_CREDENTIALS}

                        gcloud config set project ${GCP_PROJECT}

                        gcloud auth configure-docker --quiet

                        docker build --network=host -t gcr.io/${GCP_PROJECT}/ml-project:latest .

                        docker push gcr.io/${GCP_PROJECT}/ml-project:latest 


                        '''
                    }
                }

            }
        }
    }
}