# variables.tf

variable "access_key" {
   default = "<PUT IN YOUR AWS ACCESS KEY or use 'export TF_VAR_access_key='>"
}

variable "secret_key" {
   default = "<PUT IN YOUR AWS SECRET KEY or use 'export TF_VAR_secret_key='>"
}

variable "region" {
   default = "eu-central-1"
}

variable "availabilityZone" {
   default = "eu-central-1a"
}

variable "instanceType" {
   default = "t2.micro"
}

variable "instanceName" {
   default = "devops-hw14-builder"
}

variable "keyName" {
   default = "devops-hw14-builder-key"
}

variable "keyFile" {
   default = "./devops-hw14-builder.key"
}

variable "dataFile" {
   default = "./devops-hw14-builder.yml"
}

variable "gitRepo" {
   default = "https://github.com/boxfuse/boxfuse-sample-java-war-hello.git"
}

variable "workingDir" {
   default = "repo"
}

variable "securityGroup" {
   default = "devops-hw14-builder-sg"
}

# Ubuntu 22.04
variable "ami" {
   default = "ami-0caef02b518350c8b"
}

# end of variables.tf
