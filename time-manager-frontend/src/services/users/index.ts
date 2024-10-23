import http from "../api";
import type { ApiResponse } from "../types";
import { type User, type UserRequest } from "./types";

async function getUsers(email: string | null = null, username: string | null = null) {
  const queryParams: Record<string, string> = {};

  if (email) queryParams.email = email;
  if (username) queryParams.username = username;

  const queryString = new URLSearchParams(queryParams).toString();
  const url = queryString ? `users?${queryString}` : "users";

  return await http.get<ApiResponse<User[]>>(url);
}

async function createUser(data: UserRequest) {
  return await http.post<ApiResponse<User>>("users", data);
}

async function getUser(id: string) {
  return await http.get<ApiResponse<User>>(`users/${id}`);
}

async function getProfil() {
  return await http.get<ApiResponse<User>>("/accounts/profile/self")
}

async function updateUser(id: string, data: Partial<UserRequest>) {
  return await http.put<ApiResponse<User>>(`users/${id}`, data);
}

async function deleteUser(id: string) {
  return await http.delete<ApiResponse<boolean>>(`users/${id}`);
}

export default {
  getUser,
  getProfil,
  getUsers,
  createUser,
  updateUser,
  deleteUser,
};