import type { User } from "../users/types"

export interface LoginRequest {
  email: string,
  password: string
}

export interface LoginResponse {
  csrf_token: string,
  user: User
}
