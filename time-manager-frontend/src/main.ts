import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ToastPlugin from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-bootstrap.css';

import App from './App.vue'
import router from './router'
import './vee-validate.config'
const app = createApp(App)

app.use(createPinia())
app.use(ToastPlugin);
app.use(router)

app.mount('#app')
