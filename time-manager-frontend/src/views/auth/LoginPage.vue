<script setup lang="ts">
import { Form, Field, ErrorMessage } from 'vee-validate'
import { API } from "@/services";
import type { LoginRequest } from '@/services/auth/types';
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { CredentialService } from '@/utils/credentials';

const errors = ref({ email: '', password: '' });
const router = useRouter();

const signIn = async (values: any) => {
  try {
    const response = await API.auth.login(values as unknown as LoginRequest);
    CredentialService.saveCredentials(response.data.data);
    router.push({ name: 'Dashboard' });
  } catch (error: any) {
    if (error.status === 404) errors.value.email = "Email not exist"
    else if (error.status === 401) errors.value.password = "Incorect password"
    else errors.value.email = "An error occure please try again!"
  }
}
</script>

<template>
  <Form @submit="signIn">
    <div class="mb-4">
      <h3 class="mb-2"><b>Login with your email</b></h3>
    </div>
    <div class="mb-3">
      <label class="form-label">Email Address</label>
      <Field
        type="email"
        name="email"
        class="form-control"
        placeholder="Email Address"
        rules="required|email"
      />
      <ErrorMessage name="email" class="error-message" />
      <div class="error-message" id="bouncer-error_password">{{ errors.email }}</div>
    </div>
    <div class="mb-4">
      <label class="form-label">Password</label>
      <Field
        type="password"
        name="password"
        class="form-control"
        placeholder="Password"
        rules="required|min:8"
      />
      <ErrorMessage name="password" class="error-message" />
      <div class="error-message" id="bouncer-error_password">{{ errors.password }}</div>
    </div>
    <div class="flex mt-1 justify-between items-center flex-wrap">
      <div class="form-check">
        <input class="form-check-input input-primary" type="checkbox" id="customCheckc1" />
        <label class="form-check-label text-muted" for="customCheckc1">Remember me?</label>
      </div>

      <RouterLink :to="{ name: 'forgot-password' }" class="pc-link text-blue">
        <i class="font-normal text-primary-500 mb-0"></i>
        <span class="pc-mtext" style="color: #007bff">Forgot password?</span>
      </RouterLink>
    </div>
    <div class="mt-4">
      <button type="submit" class="btn btn-primary w-full">Login</button>
    </div>
  </Form>
</template>