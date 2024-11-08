import http from "../api";
import type { ApiResponse } from "../types";
import type { ActivateAccountRequest, LoginRequest } from "./types";
import type { LoginResponse } from './types';

async function login(data: LoginRequest) {
  return await http.post<ApiResponse<LoginResponse>>(`auth/register`, data);
}

async function sendResetPasswordLink(data: Partial<LoginRequest>) {
  return await http.post<ApiResponse<any>>(`auth/forgot-password`, data);
}

async function resetPassword(token: string, data: Partial<LoginRequest>) {
  return await http.post<ApiResponse<any>>(`auth/reset-password/${token}`, data);
}

async function activateAccount(token: string, data: ActivateAccountRequest) {
  return await http.post<ApiResponse<any>>(`auth/activate-account/${token}`, data);
}

async function verifyToken(email: string, token: string) {
  return await http.post<ApiResponse<any>>(`auth/verify-token/${email}/${token}`);
}

export default {
  login,
  sendResetPasswordLink,
  activateAccount,
  resetPassword,
  verifyToken
};
