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
1. Create Security groups, ssh key
1. Create EC2 instances for Builder and Webserver with IAM profile, ssh key and Security groups
1. Builder cloud-init:  
   - install maven, jdk and awscli
   - pull git repo
   - build an artifact by maven
   - copy the artifact to the S3 bucket
1. Wbeserver cloud-init:  
   - install tomcat9
   - wait until an artifact is ready
   - copy the artifact to the tomcat webdir
   - remove the artifact from S3 bucket

The key file (devops-hw14.key) is created locally to access instances via ssh. This is optionally, not necessary to deploy, just for the access to instances.

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

    # check the Builder is working
    journalctl -f
    ```

    to the Webserver

    ```bash
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
        -i ./devops-hw14.key \
        ubuntu@$(terraform output -raw webserver_dns_name)

    # check the Webserver is waiting for the artifact is ready
    # and will start it
    journalctl -f
    ```

1. Check that the application is working

    ```bash
    curl http://$(terraform output -raw webserver_dns_name):8080
    ```
