import http from "../api";
import type { ApiResponse } from "../types";
import { type Clock } from "./types";

const userId = import.meta.env.VITE_DEFAULT_USER;

async function getClocks(id: string | null = null) {
  return await http.get<ApiResponse<Clock[]>>(`clocks`);
}

async function getClock() {
  return await http.get<ApiResponse<Clock | null>>(`clocks/latest`);
}

async function createClock() {
  return await http.post<ApiResponse<Clock>>(`clocks`);
}
export default {
  getClocks,
  getClock,
  createClock
};