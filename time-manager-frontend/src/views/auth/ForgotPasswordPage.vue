<script setup lang="ts">
import { reactive, ref } from 'vue'

const formData = reactive({
  email: ''
})

const errorMessage = ref('errorMessage')
const message = ref('message')

const submitForm = async () => {}
</script>



<template>
  <form @submit.prevent="submitForm">
    <div class="flex justify-between items-end mb-4">
      <h3 class="mb-0"><b>Forgot Password</b></h3>
      <RouterLink :to="{ name: 'login' }" class="text-primary-500">Back to Login</RouterLink>
    </div>
    <div class="mb-3">
      <label class="form-label">Email Address</label>
      <input
        type="email"
        name="email"
        id="email"
        v-model="formData.email"
        class="form-control"
        placeholder="Email Address"
      />
    </div>

    <p class="mt-4 text-sm text-muted">Do not forgot to check SPAM box.</p>
    <div class="grid mt-3">
      <button type="submit" class="btn btn-primary">Send Password Reset Email</button>
    </div>
  </form>
</template>