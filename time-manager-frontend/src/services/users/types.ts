import { UserRole } from "../auth/types"

export interface User {
  id: string,
  firstname: String,
  lastname: String,
  email: String,
  role: string
}

export interface UserRequest {
  user: {
    firstname: String,
    lastname: String,
    email: String,
    role: UserRole
  }
}