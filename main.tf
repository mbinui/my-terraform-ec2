resource "aws_instance" "terraform_instance" {
  ami           = var.ami_id 
  instance_type = "t2.medium"
  key_name = var.key_pair

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y unzip wget
              https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_386.zip
              unzip terraform_1.8.2_linux_386.zip
              sudo mv terraform /usr/local/bin/
              EOF

   root_block_device {
    volume_size = 20
  }

  tags = {
    Name = "TerraformInstance"
  }
}

resource "aws_instance" "jenkins_instance" {
  ami           =  var.ami_id
  instance_type = "t2.medium"
  key_name = var.key_pair

  user_data = <<-EOF
              #!/bin/bash
              echo 'installing java package'
              sudo apt-get update -y
              sudo apt install openjdk-21-jdk -y

              sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
                https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
              echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
                https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
                /etc/apt/sources.list.d/jenkins.list > /dev/null
              sudo apt-get update
              sudo apt-get install Jenkins -y
              sudo systemctl enable jenkins.service
              sudo systemctl start jenkins.service
              EOF

  root_block_device {
    volume_size = 20
  }            

  tags = {
    Name = "JenkinsInstance"
  }
}

resource "aws_instance" "sonarqube_instance" {
  ami           = var.ami_id
  instance_type = "t2.medium"
  key_name = var.key_pair

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y openjdk-17-jdk
              sudo apt-get install -y maven
              sudo apt-get install -y unzip wget
              wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.0.0.68432.zip
              unzip sonarqube-10.0.0.68432.zip
              sudo mv sonarqube-10.0.0.68432 /opt/sonarqube
              sudo groupadd ddsonar
              sudo useradd -d /opt/sonarqube -g ddsonar ddsonar
              sudo chown -R ddsonar:ddsonar /opt/sonarqube
              sudo sh -c 'echo "RUN_AS_USER=ddsonar" >> /opt/sonarqube/bin/linux-x86-64/sonar.sh'
              sudo su - ddsonar -c "/opt/sonarqube/bin/linux-x86-64/sonar.sh start"
              EOF

  root_block_device {
    volume_size = 20
  }            

  tags = {
    Name = "Sonar-maven"
  }
}

