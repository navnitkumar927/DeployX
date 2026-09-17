import type { MonitoringSnapshot } from '../types/monitoring';

const clamp = (value: number, minimum: number, maximum: number) => Math.min(maximum, Math.max(minimum, value));
const vary = (value: number, amount: number, minimum: number, maximum: number) => Math.round(clamp(value + (Math.random() * amount * 2 - amount), minimum, maximum));

/** Replace `nextSnapshot` with a REST/WebSocket source when monitoring is connected. */
export const monitoringService = {
  initialSnapshot(): MonitoringSnapshot {
    return { cpu: 42, memory: 61, disk: 38, networkMbps: 2.4, requestsPerMinute: 1240, updatedAt: new Date() };
  },
  nextSnapshot(current: MonitoringSnapshot): MonitoringSnapshot {
    return {
      cpu: vary(current.cpu, 5, 18, 92),
      memory: vary(current.memory, 3, 35, 88),
      disk: vary(current.disk, 1, 20, 87),
      networkMbps: Number(clamp(current.networkMbps + (Math.random() * 1.4 - 0.7), 0.4, 8.5).toFixed(1)),
      requestsPerMinute: vary(current.requestsPerMinute, 95, 860, 2200),
      updatedAt: new Date(),
    };
  },
};
