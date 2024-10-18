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
import Test from '@/views/auth/Test.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/auth/',
      component: AuthLayout,

      children: [

        {
          path: 'login',
          name: 'login',
          component: LoginPage
        },
        
          {
            path: 'test',
            name: 'test',
            component: Test
          },
        
        {
          path: '',
          redirect: '/auth/login'
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
          name: 'home',
          component: DashboardPage
        },

        {
          path: 'users',
          name: 'users',
          component: UsersPage
        },
        {
          path: 'my-profile',
          name: 'user-profile',
          component: UserProfilePage
        },
        {
          path: 'workingtimes/:userID',
          name: 'workingtimes',
          component: WorkingtimesPage,
          props: true
        },
      ]
    },
  ]
})

export default router
