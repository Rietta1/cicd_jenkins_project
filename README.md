# DevOps CI/CD Project | Jenkins Shared Lib | DevSecOps |



![devopsCICD](https://github.com/Rietta1/java_app/assets/101978292/9a4b6a2b-590c-4c72-9037-31eb2aa8893e)


**DevOps Project**
Tools Used: GitHub Actions, Maven (Unit test) Sonarqube (SCA), Sonarqube (QGSC), Trivy (Image Scan), Argo CD, Docker and ECR, EKS 

Security is an integral part of a workflow. It's always recommended to integrate the shift to left security pattern in your pipelines. Better to find security vulnerabilities in the early stages of SDLC rather than in Production.

Created this project to implement the Security in our DevOps pipeline.

Step 1: Developer pushes code to GitHub

Step 2: Workflow gets triggered due to push action

Step 3: SCA is done with Sonarqube

Step 4: QGSC is done with Sonarqube

Step 5: Docker image is built and pushed to DockerHub and ECR

Step 6: Application is deployed to EKS Cluster



### Tasks
This project shows the a full cicd configuration for a java app, involving the use of 

- maven for build, 
- sonarqube for scans , 
- docker for image build, 
- ECR and Docker hub and the 
- deploying to EKS

### Tools 
installed on the server are :
- Java JDK -11
- Jenkins
- Git
- maven
- Docker
- Trivy
- Kubectl
- Sonarqube container is used
- AWS CLI
- Terraform
- Kubectl (version:1.23)


### Step 1
 Lunch an Ubuntu instance, t2 medium, and 20gb storage, add ports 8080 and 9000 to the security group for access to Jenkins and sonarqube respectively.

**Install Jenkins**

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

Grant Jenkins user and Ubuntu user permission to docker deamon.

```
sudo su - 
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
sudo systemctl restart docker

```


**Install Sonarqube**

```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

```
Now copy the public IP and add:8080 to access your Jenkins server and to access your sonarqube add:9000.

Go into your instance and change to docker permissions `sudo chmod 777 /var/run/docker.sock` 

Also, start the Sonarqube `docker container start sonarqube` and Jenkins `sudo systemctl start jenkins.service`

**Install Maven**

```
sudo apt update -y
sudo apt install maven -y
mvn -version

```

**Install trivy.sh**

```
# A Simple and Comprehensive Vulnerability Scanner for Containers and Other Artifacts, Suitable for CI.

sudo apt-get install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy

```


### Step 2
Configure your **Jenkins** `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` . Install recommended plugins  then create user.

Create a pipeline `java_app`, *no of build*, *git* add the url of your github, add the Jenkins file and create

Go to pipline syntax *git* and the url and branch and generate syntax and add it to your pipeline checkout stage.

Go to the dashboard on Jenkins, manage Jenkins, configure the system, global pipeline libraries, and add library name`jenkins_shared_lib` and add the branch at default `main`, modern SCM, git, the git library url, apply and save. 

Go to the dashboard, manage plugin, 
- install sonarqube scanner for jenkins, 
- sonar gerrit, 
- sonarqube generic coverage, 
- sonar quality gates, 
- quality gates, 
- kubectl
- note: when using docker agent, install docker pipeline

Login into sonarqube and change password, but user and password is admin.

**To configure Static code analysis: Sonarqube `http://54.245.66.159:9000`**
Go to Administration, security, user, tokens and generate a token, copy the token, go to Jenkins, manage Jenkins, configure system, SonarQube servers( check env var, name= sonar, add the sonar url), apply save. Go back to Sonarqube servers ,click on 'add' , jenkins, global credentials kind = secret text, add the token copied from sonarqube server, save and apply

**To configure Quality Gate Status Check: `http://54.245.66.159:9000`**
Go to Administration, configuration, webhook, create (add name and Jenkins url/sonarqube-webhook/ `http://54.245.66.159:8080/sonarqube-webhook/`)

**To configure docker**
Go to manage Jenkins, add credentials, add a username and password then, Go to pipeline syntax and create 'withCredentials: bind Credntials with variables',using Username and password (separated), then go and use username(USER) and password(PASS) add that to your shared lib or jenkinsfile.



**To connect AWS to Jenkins**

Go to plugins and install CloudBees AWS Credentials Version, Go to pipeline syntax = withCredentials: bind Credntials with variables , and create one using aws credentials, add Access Key ID and Secret Access Key.

OR 

Go to pipeline syntax = withCredentials: bind credentials with variables, and create one using secret text and add the access key and secret key individually. 

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

Error handling for Deploying to EKS incase if you face it

```
aws configure --profile eksadmin
export AWS_DEFAULT_PROFILE="eksadmin"
kubectl -n kube-system get configmap aws-auth -o yaml
kubectl -n kube-system edit configmap aws-auth
aws eks update-kubeconfig --name demo-cluster1 --region us-west-2

https://www.agilepartner.net/en/adding-users-to-your-eks-cluster/
```


