import { supabase, isSupabaseConfigured } from '../lib/supabase';
import type { Application, Deployment } from '../lib/types';

/** Data boundary for future API/Supabase integration. UI should not know transport details. */
export const workspaceService = {
  isConnected: isSupabaseConfigured,
  async getApplications(): Promise<Application[]> {
    if (!supabase) return [];
    const { data, error } = await supabase.from('applications').select('*').order('name');
    if (error) throw error;
    return data;
  },
  async getDeployments(): Promise<Deployment[]> {
    if (!supabase) return [];
    const { data, error } = await supabase.from('deployments').select('*').order('started_at', { ascending: false });
    if (error) throw error;
    return data;
  },
};
