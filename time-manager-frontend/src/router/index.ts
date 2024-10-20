import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import UsersPage from '@/views/UsersPage.vue'
import UserProfilePage from '@/views/UserProfilePage.vue'
import WorkingtimesPage from '@/views/WorkingtimesPage.vue'
import AuthLayout from '@/views/auth/AuthLayout.vue'
import LoginPage from '@/views/auth/LoginPage.vue'
import ForgotPasswordPage from '@/views/auth/ForgotPasswordPage.vue'
import ResetPasswordPage from '@/views/auth/ResetPasswordPage.vue'
import ActivationPage from '@/views/auth/ActivationPage.vue'
import { ToastrService } from '@/utils/toastr'
import { CredentialService } from '@/utils/credentials'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/auth/',
      component: AuthLayout,

      children: [
        {
          path: '',
          redirect: '/auth/login'
        },
        {
          path: 'login',
          name: 'login',
          component: LoginPage
        },
        {
          path: 'forgotpassword',
          name: 'forgot-password',
          component: ForgotPasswordPage
        }
        ,
        {
          path: 'resetpassword',
          name: 'reset-password',
          component: ResetPasswordPage
        }
        ,
        {
          path: 'activation',
          name: 'activation',
          component: ActivationPage
        }
      ]
    },
    {
      path: '/',
      component: DashboardLayout,
      children: [
        {
          path: '',
          name: 'dashboard',
          component: DashboardPage,
          meta: { requiresAuth: true }
        },
        {
          path: 'users',
          name: 'users',
          component: UsersPage,
          meta: { requiresAuth: true }
        },
        {
          path: 'my-profile',
          name: 'user-profile',
          component: UserProfilePage,
          meta: { requiresAuth: true }
        },
        {
          path: 'workingtimes/:userID',
          name: 'workingtimes',
          component: WorkingtimesPage,
          meta: { requiresAuth: true },
          props: true
        },
      ]
    },
  ]
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!CredentialService.isAuthentificated()) {
      return next({ name: 'login' });
    }
  }
  next();
});

export default router
