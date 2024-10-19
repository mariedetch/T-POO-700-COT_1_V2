import http from "../api";
import type { ApiResponse } from "../types";
import type { LoginRequest } from "./types";
import type { LoginResponse } from './types';

async function login(data: LoginRequest) {
  return await http.post<ApiResponse<LoginResponse>>(`auth/login`, data);
}

export default {
  login
};
