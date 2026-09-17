# 🚀 DeployX

### Production-Minded DevOps Deployment & Infrastructure Platform

DeployX is a modern DevOps platform designed to give development and infrastructure teams a **single, centralized view of applications, deployments, CI/CD pipelines, Docker images, cloud infrastructure, logs, and incidents**.

The platform provides a developer-tool-style dashboard with a responsive dark interface and includes **clearly labelled demo data and a simulated deployment pipeline**, allowing the project to be demonstrated without requiring live AWS, GitHub, or Docker Registry credentials.

---

## ✨ Features

### 📊 Deployment Dashboard

* Application deployment overview
* Availability and deployment metrics
* Resource monitoring
* Recent deployment activity
* Service health visibility

### 📦 Application Management

* Application listing and details
* Deployment history
* Application status
* Environment information
* Deployment detail drawers

### 🔄 CI/CD Pipeline

Visualize the complete deployment workflow:

```text
GitHub Push
     ↓
CI/CD Runner
     ↓
Build & Test
     ↓
Docker Image
     ↓
Private Registry
     ↓
EC2 Deployment
     ↓
Container Restart
     ↓
Health Check
     ↓
Deployment Successful
```

The current application includes a **simulated pipeline runner** for demonstration purposes.

### 🐳 Docker Registry

* Docker image inventory
* Image version history
* Immutable image tags
* Commit SHA based image identification
* Registry deployment workflow

### ☁️ AWS Infrastructure

* EC2 server monitoring
* Server health information
* Resource visibility
* Deployment target management

### 📋 Logs

* Searchable deployment logs
* Service logs
* Deployment activity
* Error and operational information

### 🚨 Incident Management

* Incident tracking
* Severity levels
* Ownership
* Incident status
* Operational visibility

### ⚙️ Workspace & Integrations

* Workspace profile
* Connected-service settings
* Supabase authentication
* Supabase database integration

---

# 🏗️ Architecture

DeployX follows a modular architecture designed to separate the frontend, persistence layer, and future infrastructure integrations.

```text
                         ┌─────────────────────┐
                         │      Developer      │
                         └──────────┬──────────┘
                                    │
                                    │ Git Push
                                    ▼
                         ┌─────────────────────┐
                         │       GitHub        │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    CI/CD Runner     │
                         │                     │
                         │ Build → Test → Scan │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   Docker Registry   │
                         │                     │
                         │ SHA Tag + Latest    │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │      AWS EC2        │
                         │                     │
                         │ Pull → Restart      │
                         │ → Health Check      │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │      DeployX        │
                         │     Dashboard       │
                         └─────────────────────┘
```

---

# 🧰 Tech Stack

## Frontend

* React
* TypeScript
* Vite
* Tailwind CSS
* ESLint

## Backend / Data

* Supabase
* PostgreSQL
* Supabase Authentication
* Row Level Security (RLS)

## DevOps

* Docker
* Docker Compose
* Nginx
* GitHub
* CI/CD
* AWS EC2
* SSH
* Private Docker Registry

## Infrastructure

* AWS EC2
* Containerized workloads
* Immutable Docker image deployments
* Health checks

---

# 📁 Project Structure

```text
DeployX/
│
├── src/
│   ├── components/
│   ├── pages/
│   ├── services/
│   │   ├── mockWorkspace.ts
│   │   └── workspace.ts
│   ├── hooks/
│   ├── types/
│   └── ...
│
├── server/
│
├── supabase/
│   └── migrations/
│
├── public/
│
├── Dockerfile.frontend
├── Dockerfile.backend
├── docker-compose.yml
├── nginx.conf
│
├── package.json
├── package-lock.json
├── vite.config.ts
├── tailwind.config.ts
├── tsconfig.json
├── eslint.config.js
│
├── .env.example
└── README.md
```

---

# 🔐 Data & Authentication Architecture

Supabase provides the persistence and authentication layer when the project is connected to a Supabase instance.

The database contains entities for:

* Profiles
* Applications
* Deployments
* Pipelines
* Docker images
* Servers
* Logs
* Incidents

Row Level Security (RLS) policies are enabled to provide workspace-level data protection.

The project also includes database triggers for:

* Profile creation
* Automatic timestamp updates

---

# 🧪 Demo Mode

DeployX is designed to be demonstrated without connecting external infrastructure.

The current UI uses intentionally created demo data from:

```text
src/services/mockWorkspace.ts
```

The Supabase integration boundary is:

```text
src/services/workspace.ts
```

The integration layer is typed and returns no workspace data until the required public Supabase environment variables are configured.

This architecture provides two benefits:

1. The application can be demonstrated without credentials.
2. Production integrations have a clearly defined service boundary.

---

# 🔄 Production Deployment Strategy

The intended production deployment strategy uses **immutable Docker images**.

```text
Developer
   │
   ▼
GitHub Push
   │
   ▼
CI/CD Pipeline
   │
   ├── Install Dependencies
   ├── Lint
   ├── Test
   ├── Build
   └── Security Scanning
   │
   ▼
Docker Build
   │
   ▼
Image Tagging
   │
   ├── <commit-sha>
   └── latest
   │
   ▼
Private Docker Registry
   │
   ▼
AWS EC2
   │
   ├── Pull Image
   ├── Stop Old Container
   ├── Start New Container
   └── Health Check
   │
   ▼
Deployment Completed
```

### Why use commit SHA tags?

Instead of deploying only:

```text
latest
```

DeployX promotes immutable images such as:

```text
deployx:8f3a91c
```

This makes deployments easier to:

* Identify
* Audit
* Reproduce
* Roll back

The same image can be promoted through environments:

```text
Build
  ↓
Staging
  ↓
Production
```

---

# 🐳 Docker

DeployX provides separate Dockerfiles for the frontend and backend.

## Frontend

`Dockerfile.frontend` uses a multi-stage build and an unprivileged Nginx image.

It provides:

* Production frontend build
* SPA routing fallback
* Static asset caching
* Compression
* Security headers
* Health endpoint
* Non-root Nginx execution

## Backend

`Dockerfile.backend` runs using the Node.js `node` user.

The current backend exposes:

```text
/healthz
```

as the initial health endpoint.

---

# 🐳 Docker Compose

The project includes:

```text
docker-compose.yml
```

The containerized stack starts the frontend on:

```text
http://localhost:8080
```

The backend remains an internal service and is **not directly published to the host**.

The frontend waits for backend health before becoming available.

Start the complete stack with:

```bash
docker compose up --build
```

Run in detached mode:

```bash
docker compose up --build -d
```

Check running containers:

```bash
docker compose ps
```

View logs:

```bash
docker compose logs -f
```

Stop the stack:

```bash
docker compose down
```

---

# 💻 Local Development

## 1. Clone the repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd DeployX
```

## 2. Install dependencies

```bash
npm install
```

## 3. Configure environment variables

Create a local environment file:

```bash
cp .env.example .env
```

Add the required Supabase project values.

## 4. Start development server

```bash
npm run dev
```

The Vite development server will display the local URL in the terminal.

---

# 🔑 Environment Variables

Create a `.env` file locally.

Example:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
```

> ⚠️ Never commit real credentials to Git.

Do not commit:

```text
.env
.env.local
AWS credentials
AWS access keys
GitHub tokens
GitLab tokens
Docker registry tokens
SSH private keys
Supabase service-role keys
Database passwords
API secrets
```

Only commit safe example configuration such as:

```text
.env.example
```

---

# 🗄️ Database Setup

The project includes a Supabase migration:

```text
create_deployx_schema
```

The migration creates the core DeployX database structure including:

* Application tables
* Deployment tables
* Pipeline tables
* Docker image records
* Server records
* Logs
* Incidents
* Profiles
* Indexes
* Row Level Security policies
* Profile creation trigger
* Timestamp triggers

Apply the migration using your configured Supabase workflow.

---

# 🔒 Security Principles

DeployX follows several production-oriented security practices.

### Application

* Typed service boundaries
* Environment-based configuration
* No hard-coded secrets
* Authentication through Supabase
* Row Level Security

### Docker

* Multi-stage frontend build
* Non-root container execution
* Minimal runtime image
* Internal backend networking

### Deployment

* Immutable image tags
* Commit SHA deployments
* Health verification
* Controlled image promotion
* SSH-based EC2 deployment

---

# 📈 Future Improvements

The project is structured to support additional production integrations.

Planned improvements include:

* [ ] Real GitHub webhook integration
* [ ] GitHub Actions integration
* [ ] Real Docker Registry integration
* [ ] AWS EC2 API integration
* [ ] Live server metrics
* [ ] Real-time deployment logs
* [ ] Automated rollback
* [ ] Blue/Green deployments
* [ ] Canary deployments
* [ ] Kubernetes deployment support
* [ ] Terraform infrastructure provisioning
* [ ] Prometheus metrics
* [ ] Grafana dashboards
* [ ] Trivy container scanning
* [ ] SonarQube code-quality integration
* [ ] Deployment notifications
* [ ] Role-based access control
* [ ] Audit logging

---

# 🎯 DevOps Learning Objectives

This project demonstrates practical concepts across the DevOps lifecycle:

```text
Source Control
      ↓
CI/CD
      ↓
Containerization
      ↓
Container Registry
      ↓
Cloud Infrastructure
      ↓
Automated Deployment
      ↓
Health Monitoring
      ↓
Logging
      ↓
Incident Management
      ↓
Security
```

It is designed as a portfolio project to demonstrate how a modern deployment platform can connect **application development, CI/CD, containers, cloud infrastructure, monitoring, and operational workflows**.

---

# 🛠️ Useful Commands

### Development

```bash
npm install
npm run dev
npm run build
npm run lint
```

### Docker

```bash
docker build -f Dockerfile.frontend -t deployx-frontend .
docker build -f Dockerfile.backend -t deployx-backend .

docker compose up --build
docker compose ps
docker compose logs -f
docker compose down
```

### Git

```bash
git status
git add .
git commit -m "Update DeployX"
git push
```

---

# 📌 Project Status

**Current status:** 🚧 Active Development

The current release focuses on the DeployX dashboard, demo workspace, Supabase integration boundary, Docker architecture, and production-oriented deployment design.

Live cloud integrations are intentionally separated from the demo environment so the platform can be showcased safely without exposing infrastructure credentials.

---

# 👨‍💻 Author

**Navnit Rathore**

DevOps Engineer | Cloud & DevSecOps Enthusiast

Areas of interest:

* AWS
* DevOps
* DevSecOps
* Docker
* Kubernetes
* CI/CD
* Terraform
* Cloud Security
* Infrastructure Automation

---

## ⭐ Support

If you find this project useful, consider giving the repository a ⭐ star.

Built with a focus on **automation, reliability, security, and scalable DevOps workflows.**
