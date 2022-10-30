# devops-hw14

### Build and Depoly an application on AWS EC2 resources by Terraform

Simple Tomcat application based on the test project:

[https://github.com/LovingFox/boxfuse-sample-java-war-hello.git](https://github.com/LovingFox/boxfuse-sample-java-war-hello.git)

#### Files

1. *main.tf* (main Terraform config)
1. *\*.tf* (other Terraform files)
1. *devops-hw14-builder.yml* (Builder cloud-init config)
1. *devops-hw14-webserver.yml* (Webserver cloud-init config)

#### Logic of the provisioning

1. Create S3 bucket
1. Create IAM role/policy/profile to access S3 (AmazonS3FullAccess)
1. Create EC2 instances for Builder and Webserver
1. Builder install maven, pull git repo, build an artifact and puch it to the S3 bucket
1. Wbeserver install tomcat9 and wait until an artifact is ready, next Webserver pull it to the tomcat webdir and remove the artifact from S3 bucket

Additionally a key file (devops-hw14.key) is created locally to access instances via ssh.

> Deploy process adds all necessary objects in AWS  
> Destroy process deletes all objects that created at Deploy

#### Usage

1. Download repository

    ```bash
    git clone https://github.com/LovingFox/devops-hw14.git
    cd devops-hw14
    ```

1. Set AWS credentials

    ```bash
    export TF_VAR_access_key="<your AWS access key>"
    export TF_VAR_secret_key="<your AWS secret key>"
    ```

1. Deploy

    ```bash
    terraform apply
    ```

1. Destroy

    ```bash
    terraform destroy
    ```

1. (Optional) Access to instances

    to the Builder

    ```bash
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
        -i ./devops-hw14.key \
        ubuntu@$(terraform output -raw builder_dns_name)
    ```

    to the Webserver

    ```bash
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
        -i ./devops-hw14.key \
        ubuntu@$(terraform output -raw webserver_dns_name)
    ```
