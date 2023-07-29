# DevOps CI/CD Project | Jenkins Shared Lib | DevSecOps |

### Tasks
This projects shows the a full cicd configuration for a java app, involving the use of 

- maven for build, 
- sonarqube for scans , 
- docker for image buld, 
- ECR and Docker hub and the 
- deploying to eks

### Tools 
installed on the server are :
- Java JDK -11
- Jenkins
- Git
- maven
- Docker
- Tinny
- Kubectl
- Sonarqube container is used
- AWS cli
- Terraform
- Kubectl (version:1.23)

### Step 1
 Lunch an ubuntu instance , t2 medium and 20gb storage, add port 8080 and 9000 to the security group for access to jenkins and sonarqube respectivly.

**Install jenkins**

```
#!/bin/bash

sudo apt update -y

sudo apt upgrade -y 

sudo apt install openjdk-11-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y

```

**Install Docker**

```
#!/bin/bash
sudo apt update -y

sudo apt install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" -y

sudo apt update -y

apt-cache policy docker-ce -y

sudo apt install docker-ce -y

#sudo systemctl status docker

sudo chmod 777 /var/run/docker.sock

```

**Install Sonarqube**

```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

```
Now copy the public ip and add :8080 to access your jenkins server and to access your sonarqube add :9000.

Go into your instance and change to docker permissions `sudo chmod 777 /var/run/docker.sock` 

Also start the Sonarqube `docker container start sonarqube` and Jenkins `sudo systemctl start jenkins.service`

**Install Maven**

```
sudo apt update -y
sudo apt install maven -y
mvn -version

```

**Install trivy.sh**

```
# A Simple and Comprehensive Vulnerability Scanner for Containers and other Artifacts, Suitable for CI.

sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

```


### Step 2
Configure your **jenkins** `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` . Install recommended plugins  then create user.

Create a pipeline `java_app`, *no of build* , *git* add the url of your github, add the Jenkins file and create

Go to pipline syntax *git* and the url and branch and generate syntax and add it to your pipeline checkout stage.

Go to dashboard on jenkins, manage jenkins, configure system, global pipeline libraries and add library name`jenkins_shared_lib` and add the branch `main`, modern SCM , git , the git library url, apply and save. 

Go to dashboard, manage plugin , 
- install sonarqube scanner for jenkins, 
- sonar gerrit, 
- sonarqube generic coverage, 
- sonar quality gates, 
- quality gates, 
- kubectl

Login into sonarqube and change password, but user and password is admin.

**To configure Static code analysis: Sonarqube `http://54.245.66.159:9000`**
Go to Administration , security, user , tokens and generate a token, copy the token, go to jenkins, manage jenkins , configure system , SonarQube servers( check env var, name= sonar , add the sonar url), apply save. Go back click on add , jenkins, global credentials kind = secret text, add the token copied from sonarqube server, save and apply

**To configure Quality Gate Status Check : `http://54.245.66.159:9000`**
Go to Administration, configuration, webhook, create (add name and jenkins url/sonarqube-webhook/ `http://54.245.66.159:8080/sonarqube-webhook/`)

**To configure docker**
Go to pipeline syntax = withCredentials: bind Credntials with variables , and create one using secret text and the password , then go and use username(USER) and password(PASS) seperatedfor docker



**To connect AWS to Jenkins**

Go to plugins and install CloudBees AWS CredentialsVersion, Go to pipeline syntax = withCredentials: bind Credntials with variables , and create one using aws credentials, add your username and the password ,

OR 

Go to pipeline syntax = withCredentials: bind Credntials with variables , and create one using secret text and add the access key and secret key individually. 

**Install aws cli**
install aws cli and configure 

```
sudo apt update
sudo apt install awscli
aws --version
aws configure

```

Use this link https://www.youtube.com/watch?v=iiF2iQV-3eM&t=916s

### Step 3
**Deploy to EKS**
ADD or Write the eks module , write the deployment.yaml file, added the different stages to your jenkins file
**install terraform**

```


sudo apt-get install unzip

wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip

unzip terraform_1.0.7_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version 

```

**Install Kubectl**

```
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.17/2023-05-11/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH
which kubectl
sudo cp kubectl /usr/local/bin
https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html
```
