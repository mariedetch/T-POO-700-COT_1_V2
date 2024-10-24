<script>
import "form-wizard-vue3/dist/form-wizard-vue3.css";  
import axios from 'axios';

export default {
  name: "App",
  data() {
    return {
      tel: "", 
      password: "", 
      confirmPassword: "", 
      token: "",
    };
  },
  mounted() {
    const urlParams = new URLSearchParams(window.location.search);
    this.token = urlParams.get('token');
  },
  methods: {
    async wizardCompleted() {
      console.log('Token récupéré :', this.token);
      if (this.password !== this.confirmPassword) {
        console.error('Les mots de passe ne correspondent pas.');
        alert('Les mots de passe ne correspondent pas.');
        return;
      }
    
      const data = {
        user: {
          tel: this.tel,
          password: this.password,
        }
      };
    
      try {
        const response = await axios.post(`api/auth/activate-account/${this.token}`, data);
        console.log('Compte activé :', response.data);
        alert('Account successfully activated !');
      } catch (error) {
        console.error('Échec de l\'activation :', error.response?.data);
        alert('Failed to activate : ' + error.response?.data.message || 'There is an error');
      }
    }
  },
};
</script>

<template>
  <form @submit="wizardCompleted"> 
    <div class="mb-4">
      <h3 class="mb-2">
        <b>Account activation</b>
      </h3>
      <p class="text-muted">Please enter your credentials</p>
    </div>
    <div class="mb-3">
      <div class="mb-3">      
        <label class="form-label">Phone number</label>
        <input type="phone" class="form-control" placeholder="Photo number" v-model="tel"> 
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="password" class="form-control" placeholder="Confirm" v-model="password">
      </div>
      <div class="mb-4">
        <label class="form-label">Comfirm Password</label>
        <input type="password" class="form-control" placeholder="comfirm your password" v-model="confirmPassword"> 
      </div>
    </div>
    <button type="submit" class="btn btn-primary w-full">Activate</button>
  </form>
</template>

