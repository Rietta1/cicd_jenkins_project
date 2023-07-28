# DevOps CI/CD Project | Jenkins Shared Lib | DevSecOps |

### Tasks
This projects shows the a full cicd configuration for a java app, involving the use of 
- (docker agents)
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
- Docker
- Tinny
- Kubectl
- Sonarqube container is used

### Step 1
 Lunch an ubuntu instance , t2 medium and 20gb storage, add port 8080 and 9000 to the security group for access to jenkins and sonarqube respectivly.

Install jenkins

```
#!/bin/bash

sudo apt update -y

sudo apt upgrade -y 

sudo apt install openjdk-17-jre -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y 
sudo apt-get install jenkins -y

```

Install Docker

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

Install Sonarqube

```
docker run -d --name sonarqube -p 9000:9000 -p 9092:9092 sonarqube

```
Now copy the public ip and add :8080 to access your jenkins server and to access your sonarqube add :9000.

Go into your instance and change to docker permissions `sudo chmod 777 /var/run/docker.sock` 

Also start the Sonarqube `docker container start sonarqube` and Jenkins `sudo systemctl start jenkins.service`



### Step 2
Configure your **jenkins** `sudo cat /var/lib/jenkins/secrets/initialAdminPassword` . Install recommended plugins  then create user.

Create a pipeline `java_app`, *no of build* , *git* add the url of your github, add the Jenkins file and create

Go to pipline syntax *git* and the url and branch and generate syntax and add it to your pipeline checkout stage.

Go to dashboard on jenkins, manage jenkins, configure system, global pipeline libraries and add library name`jenkins_shared_lib` and add the branch `main`, modern SCM , git , the git library url, apply and save. 

Go to dashboard, manage plugin , install sonarqube scanner for jenkins, sonar gerrit, sonarqube generic coverage, sonar quality gates, quality gates

Login into sonarqube and change password, but user and password is admin.

To configure Static code analysis: Sonarqube `http://54.245.66.159:9000`
Go to Administration , security, user , tokens and generate a token, copy the token, go to jenkins, manage jenkins , configure system , SonarQube servers( check env var, name= sonar , add the sonar url), apply save. 

To configure Quality Gate Status Check : `http://54.245.66.159:9000`
Go to Administration, configuration, webhook, create (add name and jenkins url)

