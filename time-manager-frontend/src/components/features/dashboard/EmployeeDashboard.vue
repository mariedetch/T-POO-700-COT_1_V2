<script setup lang="ts">
import { onMounted, toRefs, ref } from 'vue'
import Linechart from '@/components/features/charts/Linechart.vue'
import ClockChart from '@/components/features/charts/ClockChart.vue'
import WorkingChart from '@/components/features/charts/WorkingChart.vue'
import { useAuthStore } from '@/stores/auth';
import userService from '@/services/users';
import type { TeamStats } from '@/services/teams/types';

const props = defineProps({
  userId: String
})

const authStore = useAuthStore();
const { authUser } = toRefs(authStore);
const userStats = ref<Partial<TeamStats> | null>();

onMounted(async () => {
  const userID = props.userId ?? authUser.value?.id;
  if (userID) {
    userStats.value = (await userService.getUserStats(userID)).data.data;
    console.log(userStats.value)
  }
});
</script>

<template>
  <main>
    <div class="grid grid-cols-12 gap-x-6">
      <div class="col-span-12 xl:col-span-3 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Daily hours worked</h6>
            <h4 class="mb-3">
              <span class="badge bg-primary-500/10 border border-primary-500 text-primary-500"
                ><i class="ti ti-trending-up"></i>{{ userStats?.daily_avg ?? 0 }} hours</span
              >
            </h4>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Weekly hours worked</h6>
            <h4 class="mb-3">
              <span class="badge bg-success-500/10 border border-success-500 text-success-500"
                ><i class="ti ti-trending-up"></i>{{ userStats?.weekly_avg ?? 0 }} hours</span
              >
            </h4>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Monthly hours worked</h6>
            <h4 class="mb-3">
              <span class="badge bg-warning-500/10 border border-warning-500 text-warning-500"
                ><i class="ti ti-trending-down"></i>{{ userStats?.weekly_avg ?? 0 }} hours</span
              >
            </h4>
          </div>
        </div>
      </div>
      <div class="col-span-12 xl:col-span-9 md:col-span-12">
        <div class="card">
          <div class="card-header flex items-center justify-between">
            <h5 class="mb-0">Hours worked vs. hours planned</h5>
          </div>
          <div class="card-body">
            <Linechart/>
          </div>
        </div>
      </div>

      <div class="col-span-12 lg:col-span-6 flex flex-col gap-y-4">
        <div class="card">
          <div class="card-body">
            <WorkingChart :userId="userId"/>
          </div>
        </div>
      </div>

      <div class="col-span-12 lg:col-span-6 flex flex-col gap-y-4">
        <div class="card">
          <div class="card-body">
            <ClockChart :userId="userId" />
          </div>
        </div>
      </div>
    </div>
  </main>
</template>