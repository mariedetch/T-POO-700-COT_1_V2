import { CredentialService } from '@/utils/credentials';
import axios from 'axios';
import router from '@/router';
import { ToastrService } from '@/utils/toastr';

const instance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'c-xsrf-token': CredentialService.getToken() ?? ''
  },
  withCredentials: true
});

const defaultInstance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  }
});

instance.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error && error.status === 401) {
      CredentialService.clearCredentials();
      ToastrService.error("Session expired");
      router.push({ name: 'login' });
    }
    return Promise.reject(error);
  }
);

export { instance, defaultInstance }