import http from "../api";
import type { ApiResponse } from "../types";
import { type Workingtime, type WorkingtimeRequest } from "./types";

async function getWorkingtimes(userID: string,) {
  return await http.get<ApiResponse<Workingtime[]>>(`workingtime/${userID}`);
}

async function getWorkingtime(userID: string, id: string) {
    return await http.get<ApiResponse<Workingtime[]>>(`workingtime/${userID}/${id}`);
  }

async function createWorkingtime(userID: string, data: WorkingtimeRequest) {
  return await http.post<ApiResponse<Workingtime>>(`workingtime/${userID}`, data);
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
};