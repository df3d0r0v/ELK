pipeline {
    agent any
     parameters {
        string(name: 'Tag', defaultValue: '1.0.5', description: 'Git tag')
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

                        cat JENKINS_HOME/jobs/$JOB_NAME/builds/lastSuccessfulBuild/log > JENKINS_HOME/changelog

                        sleep 1000
                        terraform destroy -auto-approve -var="tag=${Tag}"
                    '''
            }
        }
    }
}
