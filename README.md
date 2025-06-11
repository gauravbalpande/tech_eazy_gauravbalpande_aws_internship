# EC2 Deployment Automation

This project automates the provisioning and deployment of a Java application on AWS EC2 using Terraform, shell scripts, and GitHub Actions.

---

## Features

- Launches EC2 instances based on the environment (dev/prod)
- Installs Java 19
- Clones and builds a Spring Boot app from GitHub
- Runs the app and checks port 80 for health
- Uploads logs to a private S3 bucket
- Attaches IAM roles with S3 permissions
- Automatically shuts down EC2 after 10 minutes
- Triggered via GitHub Actions on push or tag

---

## Repository Structure

```
.
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── dev_config.tfvars
│   ├── prod_config.tfvars
├── scripts/
│   └── setup.sh
├── github-actions/
│   └── deploy.yml
├── .env.example
```

---

## Prerequisites

- AWS Free Tier Account
- IAM user with programmatic access
- AWS CLI installed and configured locally (for manual runs)
- GitHub repo secrets:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

---

## Setup

### 1. Clone the Repo
```bash
git clone <your-fork-url>
cd <project>
```

### 2. Configure `.env`
Copy and update your credentials:
```bash
cp .env.example .env
```

### 3. Choose Your Stage
- `dev_config.tfvars`
- `prod_config.tfvars`

Modify instance type, S3 bucket name, etc.

---

## Deploy Manually (Terraform)
```bash
cd terraform
terraform init
terraform apply -var-file=dev_config.tfvars
```

To destroy:
```bash
terraform destroy -var-file=dev_config.tfvars
```

---

## Deploy via GitHub Actions
Push to `main` or tag with:
- `deploy-dev` for development
- `deploy-prod` for production

GitHub Actions will:
1. Provision infrastructure
2. Deploy app via user-data script
3. Poll port 80 to confirm health

---

## Outputs

- Public IP of EC2 instance
- Logs uploaded to:
  - `s3://<bucket>/logs/setup.log`
  - `s3://<bucket>/logs/cloud-init.log`

---

## IAM Roles

- **s3-read-only-role**: Can list and read objects from S3
- **s3-write-only-role**: Can create/upload objects (no read access)

---

## S3 Bucket Lifecycle

- Auto-deletes logs under `logs/` after 7 days.

---

## Notes

- Java 19 is installed via `yum`
- App is cloned from:
  https://github.com/techeazy-consulting/techeazy-devops
- Make sure bucket names are unique in AWS