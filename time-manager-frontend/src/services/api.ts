import { CredentialService } from '@/utils/credentials';
import axios from 'axios';

const instance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'c-xsrf-token': CredentialService.getToken() ?? ''
  },
  withCredentials: true
});
export default instance