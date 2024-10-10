import http from "../api";
import type { ApiResponse } from "../types";
import { type User, type UserRequest } from "./types";

async function getUsers() {
  return await http.get<ApiResponse<User[]>>("users");
}

async function createUser(data: UserRequest) {
  return await http.post<ApiResponse<User>>("users", data);
}

async function updateUser(id: string, data: Partial<UserRequest>) {
  return await http.put<ApiResponse<User>>(`users/${id}`, data);
}

async function deleteUser(id: string) {
  return await http.delete<ApiResponse<boolean>>(`users/${id}`);
}

export default {
  getUsers,
  createUser,
  updateUser,
  deleteUser,
};