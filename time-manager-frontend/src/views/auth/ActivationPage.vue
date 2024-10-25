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
  isLoading = ref(false),
  errors = ref(''),
  resetToken = ref('');

const submitForm = async (values: any) => {
  isLoading.value = true;
  try {
    await authService.activateAccount(resetToken.value, {
      user: {tel: values.tel.toString(), password: values.password}
    });
    ToastrService.success("Account activated successfully");
    router.push({ name: 'login' });
  } catch (error: any) {
    errors.value = "An error occure please try again!"
  } finally {
    isLoading.value = false;
  }
}

onBeforeMount(async () => {
  const { email, token } = route.query;

  if (!token || !email) {
    ToastrService.error("Missing passwork reset token");
    router.push({ name: 'login' });
  } else {
    try {
      await authService.verifyToken(email as string, token as string);
      resetToken.value = token as string;
    } catch (error: any) {
      ToastrService.error("Invalid token");
      router.push({ name: 'login' });
    }
  }
});
</script>

<template>
  <Form @submit="submitForm">
    <div class="mb-4">
      <h3 class="mb-2">
        <b>Account activation</b>
      </h3>
      <p class="text-muted">Please enter your credentials</p>
    </div>
    <div class="mb-3">
      <div class="mb-3">
        <label class="form-label">Phone number</label>
        <Field
          type="number"
          name="tel"
          class="form-control"
          placeholder="Phone number"
          rules="required|min:8"
        />
        <ErrorMessage name="tel" class="error-message" />
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <Field
          type="password"
          name="password"
          id="password"
          class="form-control"
          placeholder="Password"
          rules="required|min:8"
        />
        <ErrorMessage name="password" class="error-message" />
      </div>
      <div class="mb-4">
        <label class="form-label">Comfirm Password</label>
        <Field
          type="password"
          name="password_confirm"
          class="form-control"
          placeholder="Password"
          rules="required"
        /> <!--  -->
        <ErrorMessage name="password_confirm" class="error-message" />
      </div>
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
      <button v-else type="submit" class="btn btn-primary w-full">Activate</button>
    </div>
  </Form>
</template>

