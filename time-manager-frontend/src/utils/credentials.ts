import type { LoginResponse } from "@/services/auth/types";
import type { User } from "@/services/users/types";

export class CredentialService {

  static XSRF_KEY = 'xsrf';
  static USER_KEY = 'user';

  static saveCredentials(data: LoginResponse): void {
    localStorage.setItem(this.XSRF_KEY, data.csrf_token);
    localStorage.setItem(this.USER_KEY, JSON.stringify(data.user));
  }

  static clearCredentials(): void {
    localStorage.removeItem(this.XSRF_KEY);
    localStorage.removeItem(this.USER_KEY);
  }

  static getToken(): string | null {
    return localStorage.getItem(this.XSRF_KEY);
  }

  static isAuthentificated(): boolean {
    return !!localStorage.getItem('xsrf');
  }

  static getUser(): User | null {
    const user = localStorage.getItem(this.USER_KEY);
    return user ? JSON.parse(user) : null;
  }

}