# DeployX

DeployX is a production-minded DevOps deployment and infrastructure platform for teams that want a single, clear view of applications, CI/CD, Docker images, servers, logs, and incidents.

## Product overview

- Overview dashboard with deployment, availability, and resource metrics
- Application and deployment management with detail drawers
- Visual CI/CD pipeline from GitHub push to EC2 health check
- Docker registry inventory and image history
- AWS EC2 infrastructure monitoring
- Searchable deployment and service logs
- Incident tracking with severity and ownership
- Workspace profile and connected-service settings
- Responsive dark developer-tool interface

The interface includes clearly labelled demo data and a simulated pipeline runner so it can be demonstrated without connecting AWS, GitHub, or Docker Hub.

## Architecture

The frontend is a Vite + React + TypeScript application. Supabase provides PostgreSQL persistence and email/password authentication when connected. The database schema includes profiles, applications, deployments, pipelines, Docker images, servers, logs, and incidents with row-level security enabled.

Current UI data is deliberately demo-only and lives in `src/services/mockWorkspace.ts`. `src/services/workspace.ts` is the typed integration boundary for Supabase; it returns no data until public `VITE_SUPABASE_*` values are configured. This makes the demo safe to run without credentials and gives production code one place to replace the mock fallback.

For production, the intended flow is:

`GitHub push → CI/CD runner → Docker image → private registry → SSH to EC2 → container restart → health check`

## Local development

Install dependencies and start the already-configured Vite development server through your normal project workflow. The demo workspace is immediately available from the sign-in screen.

## Environment variables

Copy `.env.example` to your local environment and provide the Supabase project values for persisted data and authentication. Never commit real credentials, service-role keys, AWS keys, Docker tokens, GitHub tokens, or SSH private keys.

## Database setup

The project includes a Supabase migration named `create_deployx_schema` that creates the application tables, indexes, ownership policies, profile trigger, and timestamp triggers.

## Docker

- `Dockerfile.frontend` uses a multi-stage build and an unprivileged Nginx image. It includes SPA fallback, immutable asset caching, compression, security headers, and a health endpoint.
- `Dockerfile.backend` runs as the `node` user and exposes only `/healthz` until product APIs are implemented.
- `docker-compose.yml` starts the frontend on `http://localhost:8080`, waits for backend health, and does not publish the internal backend port.

Run the containerized stack with `docker compose up --build`.

## Production deployment

Build the frontend image, push an immutable commit SHA tag plus `latest`, then promote the same image through staging and production. The EC2 host should pull the selected tag, restart the container, and verify the application health endpoint before marking the deployment successful.
