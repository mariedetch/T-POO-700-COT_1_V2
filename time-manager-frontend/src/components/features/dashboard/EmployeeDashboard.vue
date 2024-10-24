<script setup lang="ts">
import { onMounted, toRefs } from 'vue'
import Linechart from '@/components/features/charts/Linechart.vue'
import ClockChart from '@/components/features/charts/ClockChart.vue'
import WorkingChart from '@/components/features/charts/WorkingChart.vue'
import { useClocksStore } from '@/stores/clocks';
import { useAuthStore } from '@/stores/auth';
import { useWorkingtimesStore } from '@/stores/workingtimes';

const props = defineProps({
  userId: String
})

const authStore = useAuthStore();
const { authUser } = toRefs(authStore);

const clockStore = useClocksStore();
const { clockList } = toRefs(clockStore);

const workingStore = useWorkingtimesStore();
const { workingtimes } = toRefs(workingStore);

onMounted(async () => {
  const userID = props.userId ?? authUser.value?.id;
  await clockStore.getClocksByUser(userID ?? '');
  await workingStore.getWorkingtimes(userID);
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
              4,42,236
              <span class="badge bg-primary-500/10 border border-primary-500 text-primary-500"
                ><i class="ti ti-trending-up"></i> 59.3%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled daily hours</p>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Weekly hours worked</h6>
            <h4 class="mb-3">
              78,250
              <span class="badge bg-success-500/10 border border-success-500 text-success-500"
                ><i class="ti ti-trending-up"></i> 70.5%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled weekly hours</p>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Monthly hours worked</h6>
            <h4 class="mb-3">
              18,800
              <span class="badge bg-warning-500/10 border border-warning-500 text-warning-500"
                ><i class="ti ti-trending-down"></i> 27.4%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled monthly hours</p>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Monthly hours worked</h6>
            <h4 class="mb-3">
              18,800
              <span class="badge bg-danger-500/10 border border-danger-500 text-danger-500"
                ><i class="ti ti-trending-down"></i> 27.4%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled monthly hours</p>
          </div>
        </div>
      </div>
      <div class="col-span-12 xl:col-span-9 md:col-span-12">
        <div class="card">
          <div class="card-header flex items-center justify-between">
            <h5 class="mb-0">Hours worked vs. hours planned</h5>
            <select class="form-select w-auto">
              <option>Today</option>
              <option>Weekly</option>
              <option :selected="true">Monthly</option>
            </select>
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