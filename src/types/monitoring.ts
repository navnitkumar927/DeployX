export interface MonitoringSnapshot {
  cpu: number;
  memory: number;
  disk: number;
  networkMbps: number;
  requestsPerMinute: number;
  updatedAt: Date;
}

export interface Automation {
  id: string;
  name: string;
  schedule: string;
  lastRun: string;
  nextRun: string;
  successRate: string;
  enabled: boolean;
}
