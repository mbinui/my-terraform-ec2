output "terraform_instance_public_ip" {
  value = aws_instance.terraform_instance.public_ip
}

output "jenkins_instance_public_ip" {
  value = aws_instance.jenkins_instance.public_ip
}

output "sonarqube_instance_public_ip" {
  value = aws_instance.sonarqube_instance.public_ip
}
