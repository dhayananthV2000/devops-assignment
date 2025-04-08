VM  Deployment using Terraform, Ansible, Docker & GitHub Actions

This project provisions an EC2 instance using Terraform, configures it with Ansible to install Docker and run a Python-based web application inside a container. It also sets up CloudWatch for centralized logging and uses GitHub Actions to build and deploy the application automatically.


---

## ✅ Tools & Services Used

- **Terraform** - Provisioning EC2, IAM, Security Groups
- **Ansible** - Installing Docker on EC2
- **Docker** - Containerizing the Python app
- **GitHub Actions** - CI/CD for building and deploying the container
- **AWS CloudWatch** - Monitoring logs (syslog + webapp logs)

---

## 🛠️ Infrastructure Setup

### 1. Provision EC2 using Terraform
- Terraform was used with modular setup to create a virtual machine in AWS with security groups and IAM roles.
- Below is the output after successful `terraform apply`:

![image](https://github.com/user-attachments/assets/6464cfff-3ff9-431e-aa10-1b5793c08ad2)

---

### 2. EC2 Instance Running

![image](https://github.com/user-attachments/assets/3bef7bf7-6da3-4bf0-ba3a-1646969a2962)


---

### 3. Installing Ansible & Docker

- Ansible was installed via `user_data` script.
- Ansible then installed Docker and created a directory for the app.
- Dockerfile and app were copied via GitHub Actions and then built/run on the EC2.

---

## 🐳 Docker Setup & Testing

### Dockerfile:

https://github.com/dhayananthV2000/devops-assignment/blob/main/ansible-config/webapp/Dockerfile

### app.py:

https://github.com/dhayananthV2000/devops-assignment/blob/main/ansible-config/webapp/app.py

---

### Testing the container (via GitHub Actions)

- The workflow first builds the image and runs a **temporary test container** on port 8080.
- It sends a `curl` request to `localhost:8080` to verify the app is returning the expected response.
- If the test is successful, the container is removed and a **production container** is launched on port 80.

📄 _Excerpt from workflow file showing test logic:_

```yaml
curl -s --fail http://localhost:8080 || {
  echo "Application test failed. Aborting deployment."
  sudo docker logs webapp-test
  sudo docker rm -f webapp-test
  exit 1
}

this is my link to workflow file:
https://github.com/dhayananthV2000/devops-assignment/blob/main/.github/workflows/deploy.yaml

⚙️ GitHub Actions
CI/CD pipeline triggers on:

Push to main branch (inside ansible-config/webapp/**)

Manual workflow dispatch


![image](https://github.com/user-attachments/assets/2a07e7f0-efc2-4f57-8c2b-c3736006b990)
![image](https://github.com/user-attachments/assets/3ab187a3-8daf-4ad8-93f3-02afe4b1e05e)

📊 CloudWatch Logs
CloudWatch agent was installed on the EC2 via user_data.

Logs forwarded:

/var/log/syslog ➝ Log group /ec2/syslog

/var/log/webapp.log ➝ Log group /ec2/webapp

![image](https://github.com/user-attachments/assets/7f081764-693b-46ec-9d82-eacdea837293)
![image](https://github.com/user-attachments/assets/5d8ce888-7e15-4919-b13b-8794970bcc30)





