export interface User {
  id: string,
  username: String,
  email: String
}

export interface UserRequest {
  user: {
    username: String,
    email: String
  }
}