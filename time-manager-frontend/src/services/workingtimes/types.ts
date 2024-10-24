import type { User } from "../users/types"

export interface Workingtime {
    id: string,
    start: string | Date,
    end: string | Date,
    user_id: String,
    user: User,
    team_id: string
  }
  
export interface WorkingtimeRequest {
  workingtime: {
      start: string | Date,
      end: string | Date,
  }
}

export interface WorkingtimeRequest_2 {
  userIDs: string[], 
  users: User[],
  workingtime: {
    start: string | Date,
    end: string | Date,
  }
}