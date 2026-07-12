# AWS ALB Host-Based & Load-Balancing Routing Demo

This project demonstrates how to set up an infrastructure on AWS with an **Application Load Balancer (ALB)** and two **EC2 Instances** hosting separate web pages. Traffic routing is configured dynamically to support both **Host-based routing** (via custom domains) and **Weighted Round-Robin Load Balancing** (via direct ALB DNS access).

## Architecture Overview

The system is deployed on AWS in the `eu-west-1` (Ireland) region and consists of:

1. **Networking Layer:**
   - **VPC** with an Internet Gateway.
   - **2 Public Subnets** spread across different Availability Zones (`eu-west-1a` and `eu-west-1b`) as required by the ALB.
   - Route tables and associations routing public traffic.

2. **Security Groups:**
   - **ALB Security Group:** Allows incoming HTTP traffic (port 80) from anywhere.
   - **EC2 Security Group:** Allows SSH (port 22) and HTTP (port 80) from anywhere (enabling direct instance IP access).

3. **Compute Layer:**
   - **2 EC2 Instances** running Ubuntu 22.04 LTS (`project1-server` and `project2-server`).
   - Configured with Nginx web server showing styled landing pages.

4. **Load Balancing & Routing:**
   - **Application Load Balancer (ALB)**.
   - **2 Target Groups** (one for each project).
   - **Host-based Routing Rules:**
     - Requests with `Host: project1.test.uk` are routed to **Project 1**.
     - Requests with `Host: project2.test.uk` are routed to **Project 2**.
   - **Default Weighted Action (50/50):** If accessed directly via the ALB DNS name (without host headers), traffic is distributed 50/50 alternately between both projects.

---

## Technology Stack

- **Terraform:** Infrastructure as Code (IaC) to provision and manage AWS resources.
- **Ansible:** Configuration management to install Nginx and deploy dynamic web pages.
- **GitHub Actions:** CI/CD pipeline automation for deployments.
- **AWS Services:** VPC, EC2, ALB.

---

## File Structure

```text
├── .github/
│   └── workflows/
│       └── deploy.yml          # CI/CD Deployment Workflow
├── ansible/
│   ├── templates/
│   │   └── index.html.j2       # Dynamic Jinja2 HTML page template
│   ├── inventory.ini           # Generated inventory file (gitignored)
│   └── playbook.yml            # Playbook to configure Nginx and pages
├── terraform/
│   ├── templates/
│   │   └── inventory.ini.tpl   # Template used to generate Ansible inventory
│   ├── main.tf                 # Main infrastructure definitions
│   ├── outputs.tf              # Terraform outputs (IPs, ALB DNS)
│   ├── providers.tf            # AWS & Local providers
│   ├── variables.tf            # Region, instance size, and keys variables
│   └── aws-alb-docker.pem      # Your private key (gitignored)
└── .gitignore                  # Git exclusions for secrets/state files
```

---

## Setup & Deployment Instructions

### Prerequisites
- AWS Account and CLI configured.
- Existing Key Pair in AWS region `eu-west-1` named `aws-alb-docker`.
- Save the private key file inside `terraform/` directory as `aws-alb-docker.pem`.

### Step 1: Provision Infrastructure with Terraform

1. Navigate to the `terraform/` directory:
   ```bash
   cd terraform
   ```
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Deploy the resources:
   ```bash
   terraform apply
   ```
   *Type `yes` to confirm.*

Once completed, Terraform will output the ALB DNS name and the public IPs of the EC2 instances. It will also automatically generate the `ansible/inventory.ini` file.

### Step 2: Configure Web Servers with Ansible

1. Navigate to the `ansible/` directory:
   ```bash
   cd ../ansible
   ```
2. Run the Ansible Playbook:
   ```bash
   ansible-playbook -i inventory.ini playbook.yml
   ```

---

## Testing the Routing

### Test 1: Weighted Round-Robin (via ALB DNS)
Open the ALB DNS in your browser or run:
```bash
curl http://<ALB_DNS_NAME>
```
Refreshing or sending multiple requests will show **Project 1** and **Project 2** alternately due to the 50/50 weighted forward configuration.

### Test 2: Host-based Routing (via custom domains)
Simulate routing using curl with Host headers:
```bash
curl -H "Host: project1.test.uk" http://<ALB_DNS_NAME>
curl -H "Host: project2.test.uk" http://<ALB_DNS_NAME>
```
*To test this in a web browser, add the ALB IP addresses to your local `/etc/hosts` file mapping to `project1.test.uk` and `project2.test.uk`.*

### Test 3: Direct EC2 IP Access
Access the EC2 instances directly in your browser:
```text
http://<PROJECT1_PUBLIC_IP>
http://<PROJECT2_PUBLIC_IP>
```
