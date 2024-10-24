import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import UserProfilePage from '@/views/UserProfilePage.vue'
import TeamCalendarPage from '@/views/TeamCalendarPage.vue'
import TeamDetailPage from '@/views/TeamDetailPage.vue'
import UsersCalendarPage from '@/views/UsersCalendarPage.vue'
import MyCalendarPage from '@/views/MyCalendarPage.vue'
import TeamsPage from '@/views/TeamsPage.vue'
import StaffPage from '@/views/StaffPage.vue'
import EmployeePage from '@/views/EmployeePage.vue'
import Punctualities from '@/views/Punctualities.vue'
import ForbiddenPage from '@/views/ForbiddenPage.vue'
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
          path: 'dashboard/:userID',
          name: 'user-dashboard',
          component: DashboardPage,
          props: true,
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER, UserRole.MANAGER]}
        },
        {
          path: '/calendar',
          name: 'calendar',
          component: MyCalendarPage,
          meta: { requiresAuth: true}
        },
        {
          path: 'calendar/:userID',
          name: 'user-calendar',
          component: UsersCalendarPage,
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER, UserRole.MANAGER] },
          props: true
        },
        {
          path: '/agenda',
          name: 'agenda',
          component: TeamCalendarPage,
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER, UserRole.MANAGER]}
        },
        {
          path: '/teams',
          name: 'teams',
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER, UserRole.MANAGER ] },
          component: TeamsPage // Lister toutes les équipes de l'entreprise ou du manager
        },
        {
          path: '/teams/:id',
          name: 'team-detail',
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER, UserRole.MANAGER] },
          props: true,
          component: TeamDetailPage // Lister les membres d'une équipe précise
        },
        {
          path: '/staff',
          name: 'staff',
          meta: { requiresAuth: true, roles: [UserRole.GENERAL_MANAGER ]},
          component: StaffPage // Lister le personnel de l'entreprise
        },
        {
          path: '/employees',
          name: 'employees',
          meta: { requiresAuth: true, roles: [UserRole.MANAGER ]},
          component: EmployeePage // Lister tous les employés du manager
        },
        {
          path: '/punctualities',
          name: 'punctualities',
          meta: { requiresAuth: true},
          component: Punctualities // Ponctualité du user connecté
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
