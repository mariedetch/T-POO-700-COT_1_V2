<script setup lang="ts">
import { Form, Field, ErrorMessage } from 'vee-validate'
import { onBeforeMount } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import authService from "@/services/auth";
import { ToastrService } from '@/utils/toastr'
import { ref } from 'vue'

const router = useRouter(),
  route = useRoute(),
  hasError = ref(false),
  errors = ref(''),
  resetToken = ref('');

const submitForm = async (values: any) => {
  try {
    await authService.resetPassword(resetToken.value, {password: btoa(values.password)});
    ToastrService.success("Password reset successfully");
    router.push({ name: 'login' });
  } catch (error: any) {
    errors.value = "An error occure please try again!"
  }
}

onBeforeMount(async () => {
  const { email, token } = route.query;

  if (!email || !token) {
    ToastrService.error("Missing passwork reset token");
    router.push({ name: 'login' });
  } else {
    try {
      await authService.verifyToken(email as string, token as string);
      resetToken.value = token as string;
    } catch (error: any) {
      hasError.value = true
    }
  }
});
</script>

<template>
  <main>
    <Form @submit="submitForm" v-if="!hasError">
      <div class="mb-4">
        <h3 class="mb-2"><b>Reset Password</b></h3>
        <p class="text-muted">Please choose your new password</p>
      </div>
      <div class="error-message mb-3">{{ errors }}</div>
      <div class="mb-3">
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
      <div class="mb-3">
        <label class="form-label">Confirm Password</label>
        <Field
          type="password"
          name="password_confirm"
          class="form-control"
          placeholder="Password"
          rules="required"
        /> <!-- |confirmed:password -->
        <ErrorMessage name="password_confirm" class="error-message" />
      </div>
      <div class="grid mt-4">
        <button type="submit" class="btn btn-primary">Reset Password</button>
      </div>
    </Form>
    <template v-else>
      <div class="mb-4">
        <h3 class="mb-2"><b>Oupss!</b></h3>
        <p class="text-muted">You're password reset link has expired or invalid, please try again</p>
      </div>
      <div class="grid mt-3">
        <RouterLink :to="{ name: 'login' }" type="button" class="btn btn-primary">Try again</RouterLink>
      </div>
    </template>
  </main>
</template>