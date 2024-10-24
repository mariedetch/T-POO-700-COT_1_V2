<script setup lang="ts">
import WorkingtimeVsClockChart from '@/components/features/charts/WorkingtimeVsClockChart.vue';
import TeamCalendarPage from './TeamCalendarPage.vue';
import { useRoute, useRouter } from 'vue-router';
import { useTeamsStore } from '@/stores/teams';
import { useAuthStore } from '@/stores/auth';
import { onMounted, toRefs } from 'vue'

const route = useRoute();
const router = useRouter();
const teamId = Array.isArray(route.params.id) ? route.params.id[0] : route.params.id;

const teamStore = useTeamsStore(),
  authStore = useAuthStore(),
  { authUser } = toRefs(authStore),
  { selectedTeam, members, stats } = toRefs(teamStore)

onMounted(async () => {
  await teamStore.getTeam(teamId)

  if (selectedTeam.value) {
    if (authUser.value) {
      if (selectedTeam.value.manager_id != authUser.value.id && authUser.value.role == 'MANAGER') {
        router.push({ name: 'forbidden'});
      }
    }
  }

  await teamStore.getStatsByTeam(teamId);
  await teamStore.getTeamMembers(teamId);
});
</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item"><router-link to="/teams">My teams</router-link></li>
          <li class="breadcrumb-item" aria-current="page">Team Details</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Team :</h2>
          <!-- <div class="text-right p-4 pb-sm-2">
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="onModalOpen()"
            >
              <i class="ti ti-plus f-18"></i> Add User</a
            >
          </div> -->
        </div>
      </div>
    </div>
    <div class="grid grid-cols-12 gap-x-6">
      <div class="col-span-12 lg:col-span-3 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <div class="flex items-center">
              <div class="shrink-0">
                <div
                  class="w-12 h-12 rounded-lg inline-flex items-center justify-center bg-primary-500/10 text-primary-500"
                >
                  <i class="ti ti-users text-2xl leading-none"></i>
                </div>
              </div>
              <div class="grow ltr:ml-3 rtl:mr-3">
                <p class="mb-1">Nb Members</p>
                <div class="flex items-center justify-between">
                  <h4 class="mb-0">{{ stats?.total_member }}</h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-12 lg:col-span-3 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <div class="flex items-center">
              <div class="shrink-0">
                <div
                  class="w-12 h-12 rounded-lg inline-flex items-center justify-center bg-warning-500/10 text-warning-500"
                >
                  <i class="ti ti-notebook text-2xl leading-none"></i>
                </div>
              </div>
              <div class="grow ltr:ml-3 rtl:mr-3">
                <p class="mb-1">Hours worked in the day</p>
                <div class="flex items-center justify-between">
                  <h4 class="mb-0">{{ stats?.daily_avg }}</h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-12 lg:col-span-3 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <div class="flex items-center">
              <div class="shrink-0">
                <div
                  class="w-12 h-12 rounded-lg inline-flex items-center justify-center bg-success-500/10 text-success-500"
                >
                  <i class="ti ti-eye text-2xl leading-none"></i>
                </div>
              </div>
              <div class="grow ltr:ml-3 rtl:mr-3">
                <p class="mb-1">Hours worked in the week</p>
                <div class="flex items-center justify-between">
                  <h4 class="mb-0">{{ stats?.weekly_avg }}</h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-12 lg:col-span-3 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <div class="flex items-center">
              <div class="shrink-0">
                <div
                  class="w-12 h-12 rounded-lg inline-flex items-center justify-center bg-danger-500/10 text-danger-500"
                >
                  <i class="ti ti-credit-card text-2xl leading-none"></i>
                </div>
              </div>
              <div class="grow ltr:ml-3 rtl:mr-3">
                <p class="mb-1">Hours worked in the month</p>
                <div class="flex items-center justify-between">
                  <h4 class="mb-0">{{ stats?.weekly_avg }}</h4>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-12">
        <div class="card new-cust-card">
          <div class="card-header"><h5>Members of the team</h5></div>
          <div class="customer-scroll" style="overflow-x: auto">
            <div class="card-body">
              <div class="flex flex-row flex-wrap gap-4">
                <div v-for="member in members" :key="member.id" 
                    class="flex items-center p-4 border rounded-lg min-w-[300px]">
                  <div class="shrink-0">
                    <img
                      src="@/assets/img/user/avatar-1.jpg"
                      alt="user image"
                      class="w-10 h-10 rounded-full"
                    />
                  </div>
                  <div class="grow mx-3">
                    <a href="#!">
                      <h6>{{ member.user.firstname + ' ' + member.user.lastname }}</h6>
                    </a>
                    <p class="m-b-0">{{ member.user.email }}</p>
                  </div>
                  <div class="shrink-0">
                    <span class="rounded-full w-2.5 h-2.5 inline-block bg-success-500"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-span-12 lg:col-span-12 flex flex-col gap-y-4">
        <TeamCalendarPage />
      </div>
    </div>
  </main>
</template>