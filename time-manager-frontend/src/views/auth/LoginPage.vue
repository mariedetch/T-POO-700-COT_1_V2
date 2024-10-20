<script setup lang="ts">
import { Form, Field, ErrorMessage } from 'vee-validate'
import { toRefs } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';

const router = useRouter();

const authStore = useAuthStore();
const { isLoading, error } = toRefs(authStore);

const signIn = async (values: any) => {
  await authStore.login(values);
  router.push({ name: 'dashboard' });
}
</script>

<template>
  <Form @submit="signIn">
    <div class="mb-4">
      <h3 class="mb-2"><b>Login with your email</b></h3>
    </div>
    <div class="error-message">{{ error }}</div>
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
      <button
        v-if="isLoading"
        class="btn btn-primary lh-1 inline-flex w-full items-center gap-3 disabled"
        type="button"
        :disabled="true"
      >
        <span
          class="flex border-[2px] border-white-500 rounded-full size-4 animate-spin border-l-transparent dark:border-l-transparent"
          role="status"
        >
          <span class="sr-only">Loading...</span>
        </span>
        Loading...
      </button>
      <button v-else type="submit" class="btn btn-primary w-full">Login</button>
    </div>
  </Form>
</template>