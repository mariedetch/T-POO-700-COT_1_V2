<script setup>
import { reactive, ref } from 'vue';


const formData =reactive({
  email:""
});

const errorMessage= ref("errorMessage");
const message=ref("message");

const submitForm = async() =>{
message.value("eedede");
  if (!formData.email) {
    alert(errorMessage);

    errorMessage.value = "Please enter an email!";
  } else if (!formData.email.includes('@')) {
    errorMessage.value = "Your email must contain '@'";
  }

  
};

</script>



<template>
  <div class="card-body sm:!p-10"><a href="#"><img src="../../assets/logo.svg" class="mb-4 img-fluid" alt="img"
        style="width:100px; height:auto;"></a>
    <div class="flex justify-between items-end mb-4">
      <h3 class="mb-0"><b>Forgot Password</b></h3>
      <RouterLink :to="{ name: 'login' }">
        <i class="text-primary-500"></i>
        <h1 v-if="message">{{ message }}</h1>
        <span class="pc-mtext" style="color: #007bff">Back to Login</span>
      </RouterLink>
      <div v-if="errorMessage" class="text-danger">{{ errorMessage }}</div>
    </div>
<form
@submit.prevent="submitForm">
    <div class="mb-3"><label class="form-label">Email Address</label>
      <input type="email" name="email" id="email" v-model="formData.email" class="form-control" placeholder="Email Address">
    </div>
  
    <p class="mt-4 text-sm text-muted">Do not forgot to check SPAM box.</p>
    <div class="grid mt-3">
      <button type="submit" class="btn btn-primary">Send Password Reset Email</button>
    </div>
  </form>

  </div>
</template>