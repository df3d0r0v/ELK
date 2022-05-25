pipeline {
    agent any
     parameters {
        string(name: 'Tag', defaultValue: '1.1.3', description: 'Git tag')
    }
    stages {
        stage('deloy elk') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '${Tag}']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/df3d0r0v/ELK.git']]])
                sh '''
                        export AWS_SHARED_CREDENTIALS_FILE=/var/lib/jenkins/.aws/credentials

                        terraform init
                        terraform plan -var="tag=${Tag}"
                        terraform apply -auto-approve -var="tag=${Tag}"

                        sleep 500
                        terraform destroy -auto-approve -var="tag=${Tag}"
                    '''
            }
        }
    }
}
