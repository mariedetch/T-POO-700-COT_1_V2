import authService from "@/services/auth";
import type { LoginRequest } from "@/services/auth/types";
import type { User } from "@/services/users/types";
import { CredentialService } from "@/utils/credentials";
import { defineStore } from "pinia"
import { computed, ref } from "vue"

export const useAuthStore = defineStore('auth', () => {
  const authUser = ref<User | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  const login = async (data: LoginRequest) => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await authService.login({
        ...data,
        password: btoa(data.password)
      });
      authUser.value = response.data.data.user

      CredentialService.saveCredentials(response.data.data);
    } catch (errors: any) {
      if (errors.status === 404) error.value = "Email not exist"
      else if (errors.status === 401) error.value = "Incorect password"
      else error.value = "An error occure please try again!"
    } finally {
      isLoading.value = false;
    }
  }

  const getAuthUser = computed(() => {
    return authUser.value ?? CredentialService.getUser();
  });

  return {
    authUser: getAuthUser,
    isLoading, error,
    login
  };
})