export type Environment = 'production' | 'staging' | 'development';
export type UserRole = 'admin' | 'developer' | 'viewer';
export type DeploymentStatus = 'queued' | 'running' | 'success' | 'failed' | 'cancelled';

export interface Application {
  id: string;
  name: string;
  repository: string;
  environment: Environment;
  current_version: string;
  docker_image: string | null;
  deployment_status: string;
  health_status: string;
  last_deployment: string | null;
}

export interface Deployment {
  id: string;
  application_id: string | null;
  application_name: string;
  version: string;
  commit_sha: string;
  environment: Environment;
  status: DeploymentStatus;
  author: string;
  stages: unknown[];
  started_at: string;
  completed_at: string | null;
  duration_seconds: number;
}
