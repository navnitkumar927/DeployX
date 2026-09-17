/**
 * Demo-only workspace data. Keep this separate from UI components so it can be
 * replaced by the workspace service when a Supabase session is available.
 */
export const applications = [
  { name: 'SWO Frontend', repo: 'github.com/navnit927/swo-frontend', env: 'production', version: 'v2.8.4', image: 'navnit927/swo-frontend:latest', deploy: '2 min ago', health: 'healthy', color: '#38bdf8' },
  { name: 'SWO Backend', repo: 'github.com/navnit927/swo-backend', env: 'production', version: 'v2.8.1', image: 'navnit927/swo-backend:9f8a21c', deploy: '18 min ago', health: 'healthy', color: '#a78bfa' },
  { name: 'Notification API', repo: 'github.com/navnit927/notification-api', env: 'staging', version: 'v1.4.0', image: 'navnit927/notification-api:latest', deploy: '1 hour ago', health: 'degraded', color: '#f59e0b' },
  { name: 'Payment API', repo: 'github.com/navnit927/payment-api', env: 'production', version: 'v3.1.2', image: 'navnit927/payment-api:7c91de2', deploy: '3 hours ago', health: 'healthy', color: '#34d399' },
] as const;

export const deployments = [
  { id: 'dep_8f21a9', app: 'SWO Frontend', version: 'v2.8.4', sha: '9f8a21c', branch: 'main', env: 'production', status: 'success', author: 'Navnit Kumar', started: '2 min ago', duration: '2m 14s' },
  { id: 'dep_7c91de', app: 'SWO Backend', version: 'v2.8.1', sha: '81ab73d', branch: 'main', env: 'production', status: 'success', author: 'Sarah Chen', started: '18 min ago', duration: '3m 42s' },
  { id: 'dep_6b23fa', app: 'Notification API', version: 'v1.4.0', sha: '7c91de2', branch: 'release/1.4', env: 'staging', status: 'failed', author: 'Mike Ross', started: '1 hour ago', duration: '1m 08s' },
  { id: 'dep_5a11cd', app: 'Payment API', version: 'v3.1.2', sha: '2bd81aa', branch: 'main', env: 'production', status: 'success', author: 'Navnit Kumar', started: '3 hours ago', duration: '4m 01s' },
  { id: 'dep_4d82ee', app: 'SWO Frontend', version: 'v2.8.3', sha: 'a92f3c1', branch: 'main', env: 'production', status: 'success', author: 'Sarah Chen', started: '5 hours ago', duration: '2m 31s' },
] as const;

export const logs = [
  ['12:42:18', 'SUCCESS', 'Health check passed — all endpoints responding within threshold'],
  ['12:42:16', 'INFO', 'Container swo-frontend restarted successfully'],
  ['12:42:09', 'INFO', 'Pulling image navnit927/swo-frontend:9f8a21c'],
  ['12:41:52', 'INFO', 'SSH connection established to prod-server-01'],
  ['12:41:38', 'INFO', 'Docker image pushed successfully (148.6 MB)'],
  ['12:40:51', 'INFO', 'Docker image build completed in 42s'],
  ['12:40:09', 'INFO', 'Running test suite — 128 tests passed'],
  ['12:39:44', 'INFO', 'GitHub Actions workflow started by push to main'],
  ['12:38:12', 'WARNING', 'Memory utilization above 70% on staging-server'],
  ['12:35:46', 'ERROR', 'Health check timeout for notification-api (retry 1/3)'],
] as const;
