export interface User {
  id: string,
  firstname: String,
  lastname: String,
  email: String,
  role: String
}

export interface UserRequest {
  user: {
    username: String,
    email: String
  }
}