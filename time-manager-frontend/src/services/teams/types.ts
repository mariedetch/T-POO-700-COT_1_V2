import type { User } from "../users/types";

export interface Team {
  id: string,
  name: string,
  description: string,
  inserted_at: string,
  manager: User | null,
  member_count: number;
}

export interface CreateTeamRequest {
  name: string,
  description: string,
  manager_id: string,
  user_ids: string[]
}

export interface UpdateTeamRequest {
  name: string,
  description: string
}
