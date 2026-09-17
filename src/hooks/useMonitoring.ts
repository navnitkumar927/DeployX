import { useEffect, useState } from 'react';
import { monitoringService } from '../services/monitoringService';
import type { MonitoringSnapshot } from '../types/monitoring';

/** Controlled polling simulation. A WebSocket subscription can replace this hook internally. */
export function useMonitoring(intervalMs = 6000) {
  const [snapshot, setSnapshot] = useState<MonitoringSnapshot>(() => monitoringService.initialSnapshot());
  const [paused, setPaused] = useState(false);

  useEffect(() => {
    if (paused) return;
    const interval = window.setInterval(() => setSnapshot(current => monitoringService.nextSnapshot(current)), intervalMs);
    return () => window.clearInterval(interval);
  }, [intervalMs, paused]);

  return { snapshot, paused, setPaused, refresh: () => setSnapshot(current => monitoringService.nextSnapshot(current)) };
}
