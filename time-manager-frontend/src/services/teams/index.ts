import http from "../api";
import type { ApiResponse, PaginationResponse } from "../types";
import type { Team, CreateTeamRequest, UpdateTeamRequest } from "./types";

async function getTeams(page: number = 1, perPage: number = 10) {
  return await http.get<ApiResponse<PaginationResponse<Team>>>(`teams?page=${page}&per_page=${perPage}`);
}

async function createTeam(data: CreateTeamRequest) {
  return await http.post<ApiResponse<Team>>("teams", data);
}

async function getTeam(id: string) {
  return await http.get<ApiResponse<Team>>(`teams/${id}`);
}

async function updateTeam(id: string, data: Partial<UpdateTeamRequest>) {
  return await http.put<ApiResponse<Team>>(`teams/${id}`, data);
}

async function deleteTeam(id: string) {
  return await http.delete<ApiResponse<boolean>>(`teams/${id}`);
}

export default {
  getTeam,
  getTeams,
  createTeam,
  updateTeam,
  deleteTeam,
};