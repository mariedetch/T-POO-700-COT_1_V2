import http from "../api";
import type { ApiResponse } from "../types";
import { type Workingtime, type WorkingtimeRequest } from "./types";

const defaultUserId = import.meta.env.VITE_DEFAULT_USER;

async function getWorkingtimes(userID: string | null = null, start: string | null = null, end: string | null = null) {
  const queryParams: Record<string, string> = {};

  if (start) queryParams.start = start;
  if (end) queryParams.end = end;

  const userId = userID ?? defaultUserId;

  const queryString = new URLSearchParams(queryParams).toString();
  const url = queryString ? `workingtimes/${userId}?${queryString}` : `workingtime/${userId}`;
  return await http.get<ApiResponse<Workingtime[]>>(url);
}

// Get workingtimes for current user
async function getCurrentUserWorkingtimes() {
  return await http.get<ApiResponse<Workingtime[]>>('workingtimes');
}

async function getWorkingtime(userID: string, id: string) {
    return await http.get<ApiResponse<Workingtime[]>>(`workingtime/${userID}/${id}`);
  }

// Le workingTime d'une équipe entière 
async function getTeamWorkingtimes(teamID: string | null = null) {

  const defaultTeamId = "ce11022e-3816-41c7-b312-bdad540d6a9f";
  const teamId = teamID ?? defaultTeamId;
  
  return await http.get<ApiResponse<Workingtime[]>>(`workingtime/team/${teamId}`);
}

async function createWorkingtime(userID: string, data: WorkingtimeRequest) {
  return await http.post<ApiResponse<Workingtime>>(`workingtime/${userID}`, data);
}

// Créer workingTime de plusieurs users dans une team
async function createTeamWorkingtime(teamID: string | null = null, data: WorkingtimeRequest) {
  const defaultTeamId = "ce11022e-3816-41c7-b312-bdad540d6a9f";
  const teamId = teamID ?? defaultTeamId;

  return await http.post<ApiResponse<Workingtime>>(`workingtime/${teamId}`, data);
}


async function updateWorkingtime(id: string, data: Partial<WorkingtimeRequest>) {
  return await http.put<ApiResponse<Workingtime>>(`workingtime/${id}`, data);
}

async function deleteWorkingtime(id: string) {
  return await http.delete<ApiResponse<boolean>>(`workingtime/${id}`);
}

export default {
  getWorkingtime,
  getWorkingtimes,
  createWorkingtime,
  updateWorkingtime,
  deleteWorkingtime,
  getCurrentUserWorkingtimes,
  getTeamWorkingtimes,
  createTeamWorkingtime
};