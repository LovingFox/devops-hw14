# variables.tf

variable "access_key" {
   default = "<PUT IN YOUR AWS ACCESS KEY or use 'export TF_VAR_access_key='>"
}

variable "secret_key" {
   default = "<PUT IN YOUR AWS SECRET KEY or use 'export TF_VAR_secret_key='>"
}

variable "projectName" {
   default = "devops-hw14"
}

variable "region" {
   default = "eu-central-1"
}

variable "bucketName" {
   default = "devops-hw14-bucket"
}

variable "bucketFileName" {
   default = "artifact.war"
}

variable "instanceType" {
   default = "t2.micro"
}

# Ubuntu 22.04
variable "ami" {
   default = "ami-0caef02b518350c8b"
}

variable "keyName" {
   default = "devops-hw14-key"
}

variable "keyFile" {
   default = "./devops-hw14.key"
}

#####################
# builder vars
variable "instanceNameBuilder" {
   default = "devops-hw14-builder"
}

variable "securityGroupBuilder" {
   default = "devops-hw14-builder-sg"
}

variable "dataFileBuilder" {
   default = "./devops-hw14-builder.yml"
}

variable "gitRepo" {
   default = "https://github.com/boxfuse/boxfuse-sample-java-war-hello.git"
}

variable "workingDir" {
   default = "/repo"
}

#####################
# webserver vars
variable "instanceNameWebserver" {
   default = "devops-hw14-webserver"
}

variable "securityGroupWebserver" {
   default = "devops-hw14-webserver-sg"
}

variable "dataFileWebserver" {
   default = "./devops-hw14-webserver.yml"
}

variable "webDir" {
   default = "/var/lib/tomcat9/webapps"
}

variable "webRoot" {
   default = "ROOT"
}

# end of variables.tf
