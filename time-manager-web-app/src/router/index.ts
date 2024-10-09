import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import UsersPage from '@/views/UsersPage.vue'

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
        }
      ]
    },
  ]
})

export default router
