import http from "../api";
import type { UserRole } from "../auth/types";
import type { TeamStats } from "../teams/types";
import type { ApiResponse } from "../types";
import { type UpdateProfileRequest, type User, type UserRequest } from "./types";

async function getUsers(email: string | null = null, username: string | null = null) {
  const queryParams: Record<string, string> = {};

  if (email) queryParams.email = email;
  if (username) queryParams.username = username;

  const queryString = new URLSearchParams(queryParams).toString();
  const url = queryString ? `users?${queryString}` : "users";

  return await http.get<ApiResponse<User[]>>(url);
}

async function getUsersByRoleAndName(role: UserRole, name: string | null = null) {
  let url = `users?role=${role}`;
  if (name) {
    url += `&firstname=${name}&lastname=${name}`;
  }
  return await http.get<ApiResponse<User[]>>(url);
}

async function createUser(data: UserRequest) {
  return await http.post<ApiResponse<User>>("users", data);
}

async function getUser(id: string) {
  return await http.get<ApiResponse<User>>(`users/${id}`);
}

async function getUserStats(id: string) {
  return await http.get<ApiResponse<Partial<TeamStats>>>(`users/${id}/stats`);
}

async function getEmployees() {
  return await http.get<ApiResponse<User[]>>(`users?role=EMPLOYEE`);
}

async function getProfil() {
  return await http.get<ApiResponse<User>>("/accounts/profile/self")
}

async function updateProfil(data: UpdateProfileRequest) {
  return await http.put<ApiResponse<User>>("/accounts/profile/self", data)
}

async function deleteProfil() {
  return await http.post<ApiResponse<User>>("/accounts/profile/self")
}
async function updateUser(id: string, data: Partial<UserRequest>) {
  return await http.put<ApiResponse<User>>(`users/${id}`, data);
}

async function deleteUser(id: string) {
  return await http.delete<ApiResponse<boolean>>(`users/${id}`);
}

// Promote an user
async function promoteUser(id: string) {
  return await http.put<ApiResponse<User>>(`users/${id}/promote`);
}

export default {
  getUser,
  getProfil,
  updateProfil,
  deleteProfil,
  getUsers,
  getEmployees,
  getUsersByRoleAndName,
  createUser,
  updateUser,
  deleteUser,
  promoteUser,
  getUserStats
};