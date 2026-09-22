# ☁️ Automated Cloud Infrastructure & Monitoring System

A production-ready Infrastructure as Code (IaC) and containerized application stack built with **Terraform**, **AWS**, **Docker**, **PostgreSQL**, and **Netdata**.

This project demonstrates an end-to-end DevOps workflow for provisioning secure cloud infrastructure automatically and orchestrating multi-container web environments with real-time performance analytics.

---

## 🏛️ System Architecture Overview

+---------------------------------------------+
                    |                 AWS Cloud                   |
                    |                                             |
                    |  +---------------------------------------+  |
                    |  |             VPC (10.0.0.0/16)         |  |
                    |  |                                       |  |
                    |  |   +-------------------------------+   |  |
                    |  |   | Public Subnet (10.0.1.0/24)   |   |  |
                    |  |   |                               |   |  |
                    |  |   |   +-----------------------+   |   |  |
                    |  |   |   |     EC2 Instance      |   |   |  |
                    |  |   |   |   (t2.micro / Ubuntu) |   |   |  |
                    |  |   |   |                       |   |   |  |
                    |  |   |   |  +-----------------+  |   |   |  |
                    |  |   |   |  | Docker Environment|  |   |   |  |
                    |  |   |   |  | - Web App (8080)|  |   |   |  |
                    |  |   |   |  | - Postgres (5432)| |   |   |  |
                    |  |   |   |  | - Netdata(19999)|  |   |   |  |
                    |  |   |   |  +-----------------+  |   |   |  |
                    |  |   |   +-----------------------+   |   |  |
                    |  |   +-------------------------------+   |  |
                    |  +---------------------------------------+  |
                    +---------------------------------------------+


                    ---

## 🛠️ Tech Stack & Key Technologies

| Category | Technology | Usage & Role |
| :--- | :--- | :--- |
| **Infrastructure as Code** | **Terraform** | Automates the provisioning of AWS network & computing resources. |
| **Cloud Provider** | **AWS** | Cloud platform hosting VPC, Subnets, Internet Gateways, and EC2 Instances. |
| **Containerization** | **Docker & Docker Compose** | Packages applications into lightweight, isolated containers. |
| **Web Server** | **Nginx / HTML5** | High-performance front-end web app service. |
| **Database** | **PostgreSQL** | Relational Database service integrated into the multi-container stack. |
| **System Monitoring** | **Netdata** | Real-time health, CPU, memory, and container performance analytics dashboard. |

---

## 📁 Repository Structure

```text
├── Dockerfile              # Docker build file for the web application
├── docker-compose.yml      # Orchestration file for Web, Database, and Netdata
├── index.html              # Web application entry point
├── README.md               # Detailed project documentation
└── terraform/
    └── main.tf             # Infrastructure specification (VPC, SG, Subnet, EC2)
🚀 Quick Start Guide (Local Development)
Prerequisites
Docker Desktop installed

Terraform CLI installed

1. Run the Multi-Container Stack
Spin up the Web Server, PostgreSQL database, and Netdata monitoring agent locally with a single command:

Bash
docker-compose up -d
2. Access the Application & Services
Once running, you can access the following services in your browser:

🌐 Web Application: http://localhost:8080

📊 Netdata Real-time Dashboard: http://localhost:19999

🗄️ PostgreSQL Database: Available on port 5432

☁️ Deploying to AWS with Terraform
To provision the infrastructure automatically on AWS:

Navigate to the Terraform directory:

Bash
cd terraform
Initialize Terraform providers:

Bash
terraform init
Validate configuration files:

Bash
terraform validate
Preview infrastructure plan:

Bash
terraform plan
Apply configuration and launch cloud resources:

Bash
terraform apply
🔐 Security & Best Practices
Network Isolation: Custom AWS VPC and Public Subnet structure instead of default network settings.

Granular Traffic Control: AWS Security Groups restricted strictly to required application ports (8080, 19999, 22).

Automated Bootstrapping: Used EC2 user_data scripts to automatically update system dependencies and start the Docker engine upon launch.
