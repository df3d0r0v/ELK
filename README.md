# Deploy ELK stack with terraform and ansible

### Setup credentials
Add AWS credentials in file ~/.aws/credentials

    [terraform]
    aws_access_key_id=<ID>
    aws_secret_access_key=<ACCESS_KEY>

Add ssh key in your AWS account with name SSH

### Deploy

    $> git clone https://github.com/df3d0r0v/ELK.git
    $> cd ELK
    $> terraform init
    $> terraform plan
    $> terraform apply

Elasic password is located in /home/ec2-user/elastic_passwd and in enviroment variable $ES_PWD

    $> cat /home/ec2-user/elastic_passwd
    $> echo $ES_PWD

### Destoroy 

    $> terraform destroy

### Ad-hoc ansible

    ansible-playbook ansible/nginx.yaml ansible/elk_stack.yaml -i 52.58.17.1,