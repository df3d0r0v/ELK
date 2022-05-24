# Deploy ELK stack with terraform and ansible

### Setup credentials
Add AWS credentials in file ~/.aws/credentials

    [terraform]
    aws_access_key_id=<ID>
    aws_secret_access_key=<ACCESS_KEY>

### Deploy

    $> git clone https://github.com/df3d0r0v/ELK.git
    $> cd ELK
    $> terraform init
    $> terraform plan
    $> terraform apply
    
### Destoroy 

    $> terraform destroy