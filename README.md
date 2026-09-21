# 🚀 DeployX

### DevOps / DevSecOps Deployment & Infrastructure Platform

DeployX is a portfolio-grade DevOps/DevSecOps platform that brings **application deployment, CI/CD, container security, infrastructure automation, code quality, and infrastructure monitoring** together around a containerized full-stack application.

The GitHub environment uses **GitHub Actions for CI/security validation**, **Jenkins for deployment automation**, **Docker Compose for runtime orchestration**, **Terraform for AWS infrastructure**, **SonarQube**, **OWASP Dependency-Check**, **Trivy**, **Prometheus**, **Grafana**, **Node Exporter**, and **Nginx**.

---

## 🏗️ Architecture

```text
Developer
   │
   ▼
GitHub Repository
   │
   ▼
GitHub Actions
   ├── Frontend Build
   ├── Backend Build
   ├── SonarQube
   ├── OWASP Dependency-Check
   └── Trivy
   │
   ▼
Pipeline Passed
   │
   ▼
Jenkins DeployX-CD
   │
   ├── git pull origin main
   ├── docker compose build
   └── docker compose up -d
   │
   ▼
AWS EC2
   │
   ├── Nginx :80
   ├── Frontend :8080
   ├── Backend :8080 (internal)
   ├── Jenkins :8081
   ├── SonarQube :9000
   ├── Prometheus :9090
   ├── Grafana :3000
   └── Node Exporter :9100
```

---

## ✨ Key Features

* GitHub source control
* GitHub Actions CI/CD
* Automated frontend and backend builds
* Docker and Docker Compose
* AWS EC2 deployment
* Terraform infrastructure provisioning
* Jenkins deployment automation
* SonarQube code-quality analysis
* OWASP Dependency-Check
* Trivy container vulnerability scanning
* Nginx reverse proxy
* Prometheus metrics collection
* Grafana dashboards
* Node Exporter host monitoring
* Backend health checks
* SSH-based GitHub access for Jenkins
* Non-root backend container execution
* Environment-based configuration

---

# 🔄 CI/CD Pipeline

```text
Git Push
   │
   ▼
┌─────────────────────┐
│       BUILD         │
│ Frontend + Backend  │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│      SECURITY       │
│                     │
│ SonarQube            │
│ OWASP                │
│ Trivy                │
└──────────┬──────────┘
           │
           ▼
    Pipeline Passed
           │
           ▼
       Jenkins CD
           │
           ▼
    Docker Compose
           │
           ▼
      Health Check
```

### GitHub Actions Jobs

| Stage    | Job              | Purpose                                    |
| -------- | ---------------- | ------------------------------------------ |
| Build    | `build_frontend` | Builds the Vite frontend                   |
| Build    | `build_backend`  | Builds the backend                         |
| Security | `sonarqube`      | Static code-quality/security analysis      |
| Security | `owasp`          | Dependency vulnerability analysis          |
| Security | `trivy`          | HIGH/CRITICAL container vulnerability scan |

The CI pipeline validates the application before deployment.

---

# 🚀 Jenkins CD

Jenkins is responsible for deployment automation.

The `DeployX-CD` pipeline performs:

```text
GitHub
   ↓
git pull origin main
   ↓
docker compose build
   ↓
docker compose up -d
   ↓
docker compose ps
   ↓
Health Check
```

Jenkins has Docker access and uses an SSH key registered with GitHub for repository access.

**Jenkins:** `:8081`

The deployment pipeline has been successfully verified using Jenkins **Build Now**.

### Automated Webhook Deployment

The next stage is connecting GitHub webhooks to Jenkins:

```text
Developer
    ↓
git push origin main
    ↓
GitHub
    ↓
Webhook
    ↓
Jenkins
    ↓
Docker Compose
    ↓
Live Deployment
```

A publicly reachable Jenkins endpoint is required for GitHub to deliver webhooks from the public Internet.

---

# ☁️ Terraform + AWS

Terraform provisions the AWS infrastructure and bootstraps the EC2 environment.

Infrastructure code:

```text
deployx-infrastructure/
```

Typical flow:

```text
Terraform
    ↓
AWS EC2
    ↓
Bootstrap / User Data
    ↓
Docker + Docker Compose
    ↓
DeployX
```

Terraform is used to manage infrastructure as code instead of manually creating the environment.

---

# 🐳 Docker

DeployX uses separate frontend and backend containers.

## Frontend

* React
* Vite
* TypeScript
* Nginx
* Production build
* Health endpoint
* Security-oriented headers

## Backend

* Node.js
* TypeScript
* Production dependencies
* Non-root `node` user
* `/healthz` endpoint
* Internal Docker networking

## Docker Compose

Start:

```bash
docker compose up --build -d
```

Check:

```bash
docker compose ps
```

Logs:

```bash
docker compose logs -f
```

Stop:

```bash
docker compose down
```

---

# 🔐 DevSecOps Security

## SonarQube

SonarQube performs static code-quality and security analysis.

Current verified status:

```text
Project: DeployX
Quality Gate: Passed
```

---

## OWASP Dependency-Check

OWASP Dependency-Check scans project dependencies for known vulnerabilities.

Reports are generated under:

```text
owasp-reports/
```

---

## Trivy

Trivy scans the backend Docker image for container vulnerabilities.

Latest verified result:

```text
HIGH:     0
CRITICAL: 0
```

---

# 📊 Monitoring & Observability

DeployX uses **Prometheus, Node Exporter, and Grafana** for infrastructure monitoring.

```text
Node Exporter
      │
      ▼
 Prometheus
      │
      ▼
   Grafana
```

| Component     |   Port | Purpose                     |
| ------------- | -----: | --------------------------- |
| Node Exporter | `9100` | EC2 host metrics            |
| Prometheus    | `9090` | Metrics collection/querying |
| Grafana       | `3000` | Monitoring dashboards       |

Prometheus scrapes Node Exporter metrics and Grafana visualizes the collected data.

The **Node Exporter Full** dashboard provides visibility into:

* CPU
* Memory
* Disk
* Network
* Load
* Uptime

---

# 🌐 Nginx

Nginx provides the HTTP reverse-proxy layer.

```text
Client
   ↓
Nginx :80
   ↓
DeployX Frontend :8080
```

The frontend container also uses Nginx to serve the production React application.

---

# 🗄️ Application & Data

DeployX contains:

* React + TypeScript frontend
* Node.js backend
* Supabase integration boundary
* PostgreSQL data model
* Authentication support
* Row Level Security support
* Demo-oriented application data

Example environment variables:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### Never commit secrets

```text
.env
AWS credentials
GitHub tokens
GitLab tokens
Docker registry credentials
SSH private keys
Database passwords
Supabase service-role keys
API secrets
```

Use GitHub Secrets or environment variables for sensitive configuration.

---

# 📁 Project Structure

```text
DeployX/
├── src/                       # React + TypeScript frontend
├── server/                    # Node.js backend
├── supabase/                  # Database migrations
├── deployx-infrastructure/    # Terraform
├── monitoring/                # Prometheus/Grafana configuration
├── security/                  # Security tooling/configuration
├── scripts/
├── docs/
├── tests/
├── Dockerfile.frontend
├── Dockerfile.backend
├── docker-compose.yml
├── nginx.conf
├── .github/
│   └── workflows/             # GitHub Actions workflows
├── package.json
├── package-lock.json
└── README.md
```

---

# 🧪 Local Development

## Clone

```bash
git clone git@github.com:navnitkumar927/DeployX.git
cd DeployX
```

## Install

```bash
npm install
```

## Environment

```bash
cp .env.example .env
```

Add the required public configuration values.

## Run

```bash
npm run dev
```

## Build

```bash
npm run build
```

## Lint

```bash
npm run lint
```

---

# 🛠️ Useful Commands

## Git

```bash
git status
git add .
git commit -m "Update DeployX"
git push origin main
```

## Docker

```bash
docker compose build
docker compose up -d
docker compose ps
docker compose logs -f
docker compose down
```

## Frontend Health

```bash
curl http://localhost:8080
```

## Backend Health

```text
GET /healthz
```

---

# 🔒 Security Practices

DeployX follows practical DevSecOps principles:

* Secrets kept outside source control
* GitHub Secrets for sensitive CI/CD configuration
* Environment-based configuration
* SSH authentication for Jenkins → GitHub
* Non-root backend container
* Dependency vulnerability scanning
* Container vulnerability scanning
* Static code analysis
* Docker health checks
* Internal backend networking
* Nginx reverse proxy
* Infrastructure as Code with Terraform
* Continuous monitoring with Prometheus/Grafana

---

# 📈 Future Enhancements

The current core DevOps/DevSecOps environment is working.

Planned improvements:

* [ ] Public Jenkins webhook endpoint
* [ ] Automated GitHub → Jenkins deployment trigger
* [ ] HTTPS with a real domain
* [ ] Automated rollback
* [ ] Blue/Green deployments
* [ ] Canary deployments
* [ ] Kubernetes deployment
* [ ] Centralized log aggregation
* [ ] Alerting and notification integrations
* [ ] Role-based access control
* [ ] Audit logging
* [ ] Backup and disaster recovery automation

---

# 🎯 DevOps / DevSecOps Learning Outcomes

```text
GitHub
   ↓
GitHub Actions
   ↓
CI/CD
   ↓
Build
   ↓
Code Quality
   ↓
Dependency Security
   ↓
Container Security
   ↓
Docker
   ↓
AWS EC2
   ↓
Jenkins Deployment
   ↓
Nginx
   ↓
Health Checks
   ↓
Prometheus
   ↓
Grafana
   ↓
Operational Monitoring
```

DeployX demonstrates how application development, infrastructure automation, CI/CD, security scanning, containerization, deployment automation, and observability can be combined into a practical DevOps/DevSecOps workflow.

---

# 📌 Current Status

### ✅ Working

* GitHub repository
* GitHub Actions CI/CD
* Frontend build
* Backend build
* SonarQube analysis
* OWASP Dependency-Check
* Trivy scanning
* Terraform EC2 infrastructure
* Docker Compose deployment
* Jenkins deployment pipeline
* Nginx reverse proxy
* Node Exporter
* Prometheus
* Grafana
* Node Exporter monitoring dashboard
* Backend health checks

### 🚧 Next

* Public webhook connectivity
* HTTPS/domain
* Automated deployment trigger
* Advanced rollback/deployment strategies

---

# 👨‍💻 Author

## Navnit Rathore

**DevOps Engineer | Cloud & DevSecOps Enthusiast**

Focus areas:

* AWS
* DevOps
* DevSecOps
* Docker
* Kubernetes
* Terraform
* CI/CD
* Cloud Security
* Infrastructure Automation
* Observability

---

## ⭐ Project

DeployX is a practical portfolio project focused on **automation, security, reliability, cloud infrastructure, deployment, and observability**.

If you find the project useful, consider giving the repository a ⭐.
