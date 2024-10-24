import type { User } from "../users/types";

export interface Team {
  id: string,
  name: string,
  description: string,
  inserted_at: string,
  manager: User | null,
  manager_id: string,
  member_count: number;
}

export interface Member {
  id: string,
  user: Partial<User>
}

export interface CreateTeamRequest {
  team: {
    name: string,
    description: string,
    manager_id: string,
    user_ids: string[]
  }
}

export interface UpdateTeamRequest {
  name: string,
  description: string
}

export interface TeamStats {
  daily_avg: Number,
  weekly_avg: Number,
  total_member: Number
}