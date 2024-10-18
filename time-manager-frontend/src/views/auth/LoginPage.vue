<script>
import * as yup from 'yup';

export default {
  data() {
    return {
      form: {
         email: '',
        password: ''
       
      },
      errors: {}
    };
  },
  methods: {
    async ValidateForm() {
      const schema = yup.object().shape({
        email: yup.string().required('Email is required').email(3, 'Email must contain "@" '),
        password: yup.string().required('Password is required')
      });

      try {
        await schema.validate(this.form, { abortEarly: false });
        // Form is valid, proceed with form submission
        alert('Form is valid!');
      } catch (err) {
        // Handle validation errors
        this.errors = {};
        err.inner.forEach(error => {
          this.errors[error.path] = error.message;
        });
      }
    }
  }
};
</script>

<template>

  <div class="card-body sm:!p-10">
    <div class="relative my-5">
      <a href="#"><img src="../../assets/logo.svg" class="mb-4 img-fluid"
        alt="img"  style="width:100px; height:auto;"></a>
    </div>
      <h4 class="text-center font-medium mb-4">Login with your email</h4>
<form @submit.prevent="validateForm">
    <div class="mb-3">
<input type="email"  v-model="form.email"class="form-control" id="floatingInput" placeholder="Email Address" required>
 <span v-if="errors.name">{{ errors.name }}</span>     
    </div>
    <div class="mb-4"><input type="password" v-model="form.password" class="form-control" id="floatingInput1" placeholder="Password" required>
    <span v-if="errors.email">{{ errors.email }}</span>  
    </div>
    <div class="flex mt-1 justify-between items-center flex-wrap">
      <div class="form-check"><input class="form-check-input input-primary" type="checkbox" id="customCheckc1"> <label
          class="form-check-label text-muted" for="customCheckc1">Remember me?</label></div>

          <RouterLink :to="{ name: 'forgot-password' }"  class="pc-link text-blue">
              <i class="font-normal text-primary-500 mb-0"></i>
              <span class="pc-mtext" style="color: #007bff">Forgot password?</span>
            </RouterLink>

    </div>
    <div class="mt-4"><button type="button" @click="ValidateForm" class="btn btn-primary w-full">Login</button></div>
   
 </form>
  </div>
  
</template>

