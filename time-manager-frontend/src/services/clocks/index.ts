import http from "../api";
import type { ApiResponse } from "../types";
import { type Clock, type ClockList } from "./types";

async function getClocks() {
  return await http.get<ApiResponse<ClockList[]>>(`clocks`);
}

async function getClocksByUser(id: string) {
  return await http.get<ApiResponse<Clock[]>>(`users/${id}/clocks`);
}

async function getClock() {
  return await http.get<ApiResponse<Clock | null>>(`clocks/latest`);
}

async function createClock() {
  return await http.post<ApiResponse<Clock>>(`clocks`);
}
export default {
  getClocksByUser,
  getClocks,
  getClock,
  createClock
};