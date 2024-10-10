import http from "../api";
import type { ApiResponse } from "../types";
import { type Clock } from "./types";

const userId = import.meta.env.VITE_DEFAULT_USER;

async function getClocks() {
  return await http.get<ApiResponse<Clock[]>>(`clocks/${userId}`);
}

async function createClock() {
  return await http.post<ApiResponse<Clock>>(`clocks/${userId}`);
}
export default {
  getClocks,
  createClock
};