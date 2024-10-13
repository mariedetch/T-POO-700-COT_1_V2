import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import UsersPage from '@/views/UsersPage.vue'
import UserProfilePage from '@/views/UserProfilePage.vue'
import WorkingtimesPage from '@/views/WorkingtimesPage.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      component: DashboardLayout,
      children: [
        {
          path: '/',
          name: 'home',
          component: DashboardPage
        },
        {
          path: '/users',
          name: 'Users',
          component: UsersPage
        },
        {
          path: '/my-profile',
          name: 'User Profile',
          component: UserProfilePage
        },
        {
          path: '/workingtimes/:userID',
          name: 'Workingtimes',
          component: WorkingtimesPage,
          props: true
        },
      ]
    },
  ]
})

export default router
