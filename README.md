# devops-hw14 !!! yet under development !!!

### Build and Depoly an application on AWS EC2 resources by Terraform

Simple Tomcat application based on the test project:

[https://github.com/LovingFox/boxfuse-sample-java-war-hello.git](https://github.com/LovingFox/boxfuse-sample-java-war-hello.git)

##### Files

1. *main.tf* (main Terraform config)

##### Usage

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
