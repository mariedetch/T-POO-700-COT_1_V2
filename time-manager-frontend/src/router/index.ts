import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import List_Team_Members_Page from '@/views/List_Team_Members_Page.vue'
import UserProfilePage from '@/views/UserProfilePage.vue'
import UsersCalendar from '@/views/UsersCalendar.vue'
import List_Teams_Page from '@/views/List_Teams_Page.vue'
import List_Employees_Page from '@/views/List_Employees_Page.vue'
import List_All_Teams_Page from '@/views/List_All_Teams_Page.vue'
import ForbiddenPage from '@/views/ForbiddenPage.vue'
import WorkingtimesPage from '@/views/WorkingtimesPage.vue'
import AuthLayout from '@/views/auth/AuthLayout.vue'
import LoginPage from '@/views/auth/LoginPage.vue'
import ForgotPasswordPage from '@/views/auth/ForgotPasswordPage.vue'
import ResetPasswordPage from '@/views/auth/ResetPasswordPage.vue'
import ActivationPage from '@/views/auth/ActivationPage.vue'
import { CredentialService } from '@/utils/credentials'
import { UserRole } from '@/services/auth/types'

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
          meta: { requiresAuth: true}
        },
        {
          path: '/team_members',
          name: 'List_Team_Members_Page',
          component: List_Team_Members_Page // Lister les membres d'une équipe précise
        },
        {
          path: '/teams',
          name: 'teams',
          component: List_Teams_Page // Lister les teams d'un manager précis
        },
        {
          path: '/employees',
          name: 'employees',
          component: List_Employees_Page // Lister tous les employés de l'entreprise
        },
        {
          path: '/all_teams',
          name: 'all_teams',
          component: List_All_Teams_Page // Lister toutes les équipes de l'entreprise
        },
        {
          path: '/calendrier',
          name: 'calendrier',
          component: UsersCalendar,
        },
        /* {
          path: 'users',
          name: 'users',
          component: UsersPage,
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER] }
        }, */
        {
          path: 'my-profile',
          name: 'user-profile',
          component: UserProfilePage,
          meta: { requiresAuth: true}
        },
        {
          path: 'workingtimes/:userID',
          name: 'workingtimes',
          component: WorkingtimesPage,
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER] },
          props: true
        },
        {
          path: 'forbidden',
          name: 'forbidden',
          component: ForbiddenPage,
          meta: { requiresAuth: true }
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

router.beforeEach((to, from, next) => {
  const requiresAuth = to.meta.requiresAuth;
  const user = CredentialService.getUser()

  if (requiresAuth && !CredentialService.isAuthentificated()) {
      return next({ name: 'login' });
  } else if (requiresAuth && Array.isArray(to.meta.roles) && !to.meta.roles.includes(user?.role)) {
    next({ name: 'forbidden' });
  } else {
    next();
  }
});

export default router
