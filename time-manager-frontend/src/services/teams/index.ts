import http from "../api";
import type { ApiResponse, PaginationResponse } from "../types";
import type { Team, CreateTeamRequest, UpdateTeamRequest, Member, TeamStats } from "./types";

async function getTeams(page: number = 1, perPage: number = 10) {
  return await http.get<ApiResponse<PaginationResponse<Team>>>(`teams?page=${page}&per_page=${perPage}`);
}

async function createTeam(data: CreateTeamRequest) {
  return await http.post<ApiResponse<Team>>("teams", data);
}

async function getTeam(id: string) {
  return await http.get<ApiResponse<Team>>(`teams/${id}`);
}

async function getTeamMembers(id: string) {
  return await http.get<ApiResponse<Member[]>>(`teams/${id}/members`);
}

async function updateTeam(id: string, data: Partial<UpdateTeamRequest>) {
  return await http.put<ApiResponse<Team>>(`teams/${id}`, data);
}

async function deleteTeam(id: string) {
  return await http.delete<ApiResponse<boolean>>(`teams/${id}`);
}

async function getStatsByTeam(id: string) {
  return await http.get<ApiResponse<TeamStats>>(`teams/${id}/stats`);
}

export default {
  getTeam,
  getTeams,
  getTeamMembers,
  getStatsByTeam,
  createTeam,
  updateTeam,
  deleteTeam,
};