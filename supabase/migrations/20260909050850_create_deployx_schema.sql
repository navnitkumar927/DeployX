/*
# DeployX — DevOps Deployment & Infrastructure Platform Schema

## Overview
Creates the full database schema for DeployX, a DevOps platform for managing
applications, CI/CD pipelines, Docker images, deployments, EC2 infrastructure,
logs, and incidents.

## New Tables
1. `profiles` — user profile data (role, full name, avatar) linked to auth.users
2. `applications` — registered applications (frontend, backend, APIs)
3. `deployments` — deployment records with pipeline stages
4. `pipelines` — CI/CD pipeline definitions and executions
5. `docker_images` — Docker registry image records
6. `servers` — EC2 infrastructure servers with metrics
7. `logs` — centralized application/deployment logs
8. `incidents` — incident management records

## Security
- RLS enabled on all tables
- All tables are owner-scoped to authenticated users via user_id or auth.uid()
- 4 CRUD policies per table (select/insert/update/delete)
- Profiles table uses auth.uid() directly as primary key
*/

-- ============================================================
-- PROFILES
-- ============================================================
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL DEFAULT '',
  role text NOT NULL DEFAULT 'developer' CHECK (role IN ('admin', 'developer', 'viewer')),
  avatar_url text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_profile" ON profiles;
CREATE POLICY "select_own_profile" ON profiles FOR SELECT
  TO authenticated USING (auth.uid() = id);

DROP POLICY IF EXISTS "insert_own_profile" ON profiles;
CREATE POLICY "insert_own_profile" ON profiles FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "update_own_profile" ON profiles;
CREATE POLICY "update_own_profile" ON profiles FOR UPDATE
  TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "delete_own_profile" ON profiles;
CREATE POLICY "delete_own_profile" ON profiles FOR DELETE
  TO authenticated USING (auth.uid() = id);

-- ============================================================
-- APPLICATIONS
-- ============================================================
CREATE TABLE IF NOT EXISTS applications (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  repository text NOT NULL,
  environment text NOT NULL DEFAULT 'production' CHECK (environment IN ('production', 'staging', 'development')),
  current_version text DEFAULT 'v1.0.0',
  docker_image text,
  deployment_status text NOT NULL DEFAULT 'idle' CHECK (deployment_status IN ('idle', 'deploying', 'success', 'failed')),
  health_status text NOT NULL DEFAULT 'healthy' CHECK (health_status IN ('healthy', 'degraded', 'down')),
  last_deployment timestamptz,
  description text DEFAULT '',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE applications ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_applications" ON applications;
CREATE POLICY "select_own_applications" ON applications FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_applications" ON applications;
CREATE POLICY "insert_own_applications" ON applications FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_applications" ON applications;
CREATE POLICY "update_own_applications" ON applications FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_applications" ON applications;
CREATE POLICY "delete_own_applications" ON applications FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- DEPLOYMENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS deployments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  application_id uuid REFERENCES applications(id) ON DELETE SET NULL,
  application_name text NOT NULL,
  version text NOT NULL,
  commit_sha text NOT NULL,
  environment text NOT NULL DEFAULT 'production',
  status text NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'running', 'success', 'failed', 'cancelled')),
  author text NOT NULL DEFAULT 'system',
  stages jsonb NOT NULL DEFAULT '[]'::jsonb,
  started_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  duration_seconds integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE deployments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_deployments" ON deployments;
CREATE POLICY "select_own_deployments" ON deployments FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_deployments" ON deployments;
CREATE POLICY "insert_own_deployments" ON deployments FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_deployments" ON deployments;
CREATE POLICY "update_own_deployments" ON deployments FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_deployments" ON deployments;
CREATE POLICY "delete_own_deployments" ON deployments FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- PIPELINES
-- ============================================================
CREATE TABLE IF NOT EXISTS pipelines (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  application_id uuid REFERENCES applications(id) ON DELETE SET NULL,
  name text NOT NULL,
  application_name text NOT NULL,
  status text NOT NULL DEFAULT 'idle' CHECK (status IN ('idle', 'queued', 'running', 'success', 'failed')),
  stages jsonb NOT NULL DEFAULT '[]'::jsonb,
  last_run timestamptz,
  last_status text DEFAULT 'idle',
  trigger text DEFAULT 'manual',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE pipelines ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_pipelines" ON pipelines;
CREATE POLICY "select_own_pipelines" ON pipelines FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_pipelines" ON pipelines;
CREATE POLICY "insert_own_pipelines" ON pipelines FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_pipelines" ON pipelines;
CREATE POLICY "update_own_pipelines" ON pipelines FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_pipelines" ON pipelines;
CREATE POLICY "delete_own_pipelines" ON pipelines FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- DOCKER IMAGES
-- ============================================================
CREATE TABLE IF NOT EXISTS docker_images (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  repository text NOT NULL,
  tag text NOT NULL,
  commit_sha text NOT NULL,
  size_mb numeric DEFAULT 0,
  environment text NOT NULL DEFAULT 'production',
  status text NOT NULL DEFAULT 'ready' CHECK (status IN ('ready', 'deploying', 'deployed', 'failed')),
  build_date timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE docker_images ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_docker_images" ON docker_images;
CREATE POLICY "select_own_docker_images" ON docker_images FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_docker_images" ON docker_images;
CREATE POLICY "insert_own_docker_images" ON docker_images FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_docker_images" ON docker_images;
CREATE POLICY "update_own_docker_images" ON docker_images FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_docker_images" ON docker_images;
CREATE POLICY "delete_own_docker_images" ON docker_images FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- SERVERS (Infrastructure)
-- ============================================================
CREATE TABLE IF NOT EXISTS servers (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  instance_type text NOT NULL DEFAULT 't3.medium',
  os text NOT NULL DEFAULT 'Ubuntu 22.04 LTS',
  status text NOT NULL DEFAULT 'running' CHECK (status IN ('running', 'stopped', 'terminated')),
  cpu_utilization numeric DEFAULT 0,
  memory_utilization numeric DEFAULT 0,
  disk_utilization numeric DEFAULT 0,
  network_traffic_mbps numeric DEFAULT 0,
  docker_status text NOT NULL DEFAULT 'healthy' CHECK (docker_status IN ('healthy', 'unhealthy', 'down')),
  nginx_status text NOT NULL DEFAULT 'running' CHECK (nginx_status IN ('running', 'stopped', 'error')),
  ip_address text,
  region text DEFAULT 'us-east-1',
  uptime_hours integer DEFAULT 0,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE servers ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_servers" ON servers;
CREATE POLICY "select_own_servers" ON servers FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_servers" ON servers;
CREATE POLICY "insert_own_servers" ON servers FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_servers" ON servers;
CREATE POLICY "update_own_servers" ON servers FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_servers" ON servers;
CREATE POLICY "delete_own_servers" ON servers FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- LOGS
-- ============================================================
CREATE TABLE IF NOT EXISTS logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  application_name text NOT NULL,
  level text NOT NULL DEFAULT 'INFO' CHECK (level IN ('INFO', 'WARNING', 'ERROR', 'SUCCESS')),
  message text NOT NULL,
  source text DEFAULT 'system',
  deployment_id uuid,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE logs ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_logs" ON logs;
CREATE POLICY "select_own_logs" ON logs FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_logs" ON logs;
CREATE POLICY "insert_own_logs" ON logs FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_logs" ON logs;
CREATE POLICY "update_own_logs" ON logs FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_logs" ON logs;
CREATE POLICY "delete_own_logs" ON logs FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- INCIDENTS
-- ============================================================
CREATE TABLE IF NOT EXISTS incidents (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL DEFAULT auth.uid() REFERENCES auth.users(id) ON DELETE CASCADE,
  title text NOT NULL,
  severity text NOT NULL DEFAULT 'medium' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  service text NOT NULL,
  status text NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'investigating', 'identified', 'resolved')),
  assigned_engineer text DEFAULT 'Unassigned',
  impact text DEFAULT '',
  root_cause text DEFAULT '',
  resolution text DEFAULT '',
  timeline jsonb NOT NULL DEFAULT '[]'::jsonb,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

ALTER TABLE incidents ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "select_own_incidents" ON incidents;
CREATE POLICY "select_own_incidents" ON incidents FOR SELECT
  TO authenticated USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "insert_own_incidents" ON incidents;
CREATE POLICY "insert_own_incidents" ON incidents FOR INSERT
  TO authenticated WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "update_own_incidents" ON incidents;
CREATE POLICY "update_own_incidents" ON incidents FOR UPDATE
  TO authenticated USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "delete_own_incidents" ON incidents;
CREATE POLICY "delete_own_incidents" ON incidents FOR DELETE
  TO authenticated USING (auth.uid() = user_id);

-- ============================================================
-- INDEXES
-- ============================================================
CREATE INDEX IF NOT EXISTS idx_applications_user_id ON applications(user_id);
CREATE INDEX IF NOT EXISTS idx_deployments_user_id ON deployments(user_id);
CREATE INDEX IF NOT EXISTS idx_deployments_status ON deployments(status);
CREATE INDEX IF NOT EXISTS idx_pipelines_user_id ON pipelines(user_id);
CREATE INDEX IF NOT EXISTS idx_docker_images_user_id ON docker_images(user_id);
CREATE INDEX IF NOT EXISTS idx_servers_user_id ON servers(user_id);
CREATE INDEX IF NOT EXISTS idx_logs_user_id ON logs(user_id);
CREATE INDEX IF NOT EXISTS idx_logs_created_at ON logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_incidents_user_id ON incidents(user_id);

-- ============================================================
-- TRIGGER: auto-create profile on signup
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name, role)
  VALUES (NEW.id, COALESCE(NEW.raw_user_meta_data->>'full_name', 'New User'), 'developer')
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- TRIGGER: update updated_at timestamps
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_profiles_updated ON profiles;
CREATE TRIGGER trigger_profiles_updated BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_applications_updated ON applications;
CREATE TRIGGER trigger_applications_updated BEFORE UPDATE ON applications
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_pipelines_updated ON pipelines;
CREATE TRIGGER trigger_pipelines_updated BEFORE UPDATE ON pipelines
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_servers_updated ON servers;
CREATE TRIGGER trigger_servers_updated BEFORE UPDATE ON servers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

DROP TRIGGER IF EXISTS trigger_incidents_updated ON incidents;
CREATE TRIGGER trigger_incidents_updated BEFORE UPDATE ON incidents
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();