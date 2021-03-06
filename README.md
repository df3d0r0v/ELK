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

### Destoroy 

    $> terraform destroy

### Ad-hoc commands and troubleshooting 

    $> ansible-playbook ansible/nginx.yaml ansible/elk_stack.yaml -i <IP>,

Elasic password is located in /home/ec2-user/elastic_passwd and in enviroment variable $ES_PWD

    $> cat /home/ec2-user/elastic_passwd
    $> echo $ES_PWD
    
Logstash status and logs

    $> systemctl status logstash.service
    $> tail -f /var/log/logstash/logstash-plain.log
    
Add logs for nginx

    $> curl 127.0.0.1
