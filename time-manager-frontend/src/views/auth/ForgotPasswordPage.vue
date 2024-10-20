<script setup lang="ts">
import { Form, Field, ErrorMessage } from 'vee-validate'
import authService from "@/services/auth";
import { ref } from 'vue'

const emailSent = ref(false)
const errors = ref({error: '', email: ''})

const submitForm = async (values: any) => {
  try {
    await authService.sendResetPasswordLink(values as unknown as any);
    emailSent.value = true;
  } catch (error: any) {
    if (error.status === 404) {
      errors.value.email = "Email not exists"
    }
    else errors.value.error = "An error occure please try again!"
  }
}
</script>

<template>
  <main>
    <Form @submit="submitForm" v-if="!emailSent">
      <div class="flex justify-between items-end mb-4">
        <h3 class="mb-0"><b>Forgot Password</b></h3>
        <RouterLink :to="{ name: 'login' }" class="text-primary-500">Back to Login</RouterLink>
      </div>
      <div class="error-message mb-3">{{ errors.error }}</div>
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
        <div class="error-message">{{ errors.email }}</div>
      </div>

      <p class="mt-4 text-sm text-muted">Do not forgot to check SPAM box.</p>
      <div class="grid mt-3">
        <button type="submit" class="btn btn-primary">Send Password Reset Email</button>
      </div>
    </Form>
    <template v-else>
      <div class="mb-4">
        <h3 class="mb-2"><b>Hi, Check Your Mail</b></h3>
        <p class="text-muted">We have sent a password recover instructions to your email.</p>
      </div>
      <div class="grid mt-3">
        <RouterLink :to="{ name: 'login' }" type="button" class="btn btn-primary">Sign in</RouterLink>
      </div>
    </template>
  </main>
</template>