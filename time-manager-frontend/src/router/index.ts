import { createRouter, createWebHistory } from 'vue-router'
import DashboardLayout from '@/views/DashboardLayout.vue'
import DashboardPage from '@/views/DashboardPage.vue'
import List_Team_Members_Page from '@/views/List_Team_Members_Page.vue'
import UserProfilePage from '@/views/UserProfilePage.vue'
import WorkingtimesPage from '@/views/WorkingtimesPage.vue'
import UsersCalendar from '@/views/UsersCalendar.vue'
import List_Teams_Page from '@/views/List_Teams_Page.vue'
import List_Employees_Page from '@/views/List_Employees_Page.vue'
import List_All_Teams_Page from '@/views/List_All_Teams_Page.vue'

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
          component: UsersCalendar
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
