export interface User {
  id: string,
  firstname: String,
  lastname: String,
  email: String,
  role: string
}

export interface UserRequest {
  user: {
    username: String,
    email: String
  }
}