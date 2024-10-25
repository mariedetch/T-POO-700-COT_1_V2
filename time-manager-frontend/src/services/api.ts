import { CredentialService } from '@/utils/credentials';
import axios from 'axios';
import router from '@/router';
import { ToastrService } from '@/utils/toastr';

const instance = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  },
  withCredentials: true
});

instance.interceptors.request.use((config) => {
  const csrfToken = CredentialService.getToken() ?? '';
  console.log(csrfToken)
  if (csrfToken) {
    config.headers['c-xsrf-token'] = csrfToken;
  }
  console.log(config.withCredentials)
  return config;
}, (error) => {
  return Promise.reject(error);
});

/*instance.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error && error.status === 401) {
      CredentialService.clearCredentials();
      ToastrService.error("Session expired");
      router.push({ name: 'login' });
    }

    else if (error && error.status === 403) {
      router.push({ name: 'forbidden' });
    }

    return Promise.reject(error);
  }
);*/

export default instance;
