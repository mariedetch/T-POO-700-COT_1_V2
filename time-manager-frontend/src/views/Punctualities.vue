<script setup lang="ts">
import { useClocksStore } from '@/stores/clocks'
import { onMounted, ref, toRefs } from 'vue'

const formatDate = (date: string) => {
  const options = { year: 'numeric', month: 'long', day: 'numeric' }
  return new Date(date).toLocaleDateString(undefined)
}

const formatTime = (date: Date) => {
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  return `${hours}:${minutes}`
}

const clockStore = useClocksStore()
const { error, clocks } = toRefs(clockStore)


onMounted(async () => {
  await clockStore.getClocks()
})
</script>


<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item"><router-link to="#">Ponctualities</router-link></li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Ponctualities</h2>
        </div>
      </div>
    </div>
    <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div>
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-header flex items-center justify-between">
            <h3>Arrival and Departure history</h3>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table table-hover" id="pc-dt-simple">
                <thead>
                  <tr>
                    <th class="text-center">Date</th>
                    <th class="text-center">History</th>
                  </tr>
                </thead>

                <tbody>
                  <tr v-for="(clock, index) in clocks" :key="index">
                    <td>{{ formatDate(clock.day) }}</td>
                    <td>
                      <ul class="list-unstyled task-list relative pl-[30px] *:mb-3">
                        <li
                          class="absolute h-full w-0.5 top-0 left-2.5 z-10 bg-theme-border dark:bg-themedark-border"
                        ></li>
                        <li
                          class="absolute rounded-full p-0.5 bottom-0 !mb-0 left-[3px] min-w-[15px] min-h-[15px] z-20 bg-theme-border dark:bg-themedark-border"
                        ></li>
                        <li v-for="item in clock.clocks" :key="item.id">
                          <template v-if="item.status">
                            <i
                              class="feather icon-check font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-success-500 text-white"
                            ></i>
                            <p class="mb-1">{{ formatTime(new Date(item.time)) }}</p>
                            <h5 class="text-muted">Arrivée</h5>
                          </template>
                          <template v-else>
                            <i
                              class="feather icon-check font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-danger-500 text-white"
                            ></i>
                            <p class="mb-1">{{ formatTime(new Date(item.time)) }}</p>
                            <h5 class="text-muted">Sortie</h5>
                          </template>
                        </li>
                      </ul>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>
