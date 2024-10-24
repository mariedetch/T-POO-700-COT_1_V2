<script setup lang="ts">

import { useClocksStore } from '@/stores/clocks';
import { onMounted, ref, toRefs } from 'vue'

const formatDate = (date: string) => {
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    return new Date(date).toLocaleDateString(undefined);
};

const formatTime = (date: Date) => {
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  return `${hours}:${minutes}`;
};

const userStore = useClocksStore()
const { getClocks, error, clocks } = toRefs(userStore)


</script>


<template>
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
                                class="absolute h-full w-0.5 top-0 left-2.5 z-10 bg-theme-border dark:bg-themedark-border">
                            </li>
                            <li
                                class="absolute rounded-full p-0.5 bottom-0 !mb-0 left-[3px] min-w-[15px] min-h-[15px] z-20 bg-theme-border dark:bg-themedark-border">
                            </li>
                            <li v-for="item in clock.clocks">
                                <template v-if="item.status">
                                    <i class="feather icon-check font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-success-500 text-white"></i>
                                    <p class="mb-1">{{ formatTime(new Date(item.time)) }}</p>
                                    <h5 class="text-muted"> Arrivée</h5>
                                </template>
                                <template v-else>
                                    <i class="feather icon-check font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-danger-500 text-white"></i>
                                    <p class="mb-1">{{ formatTime(new Date(item.time)) }}</p>
                                    <h5 class="text-muted"> Sortie</h5>
                                </template>
                            </li>
                        </ul>
                    </td>
                </tr>

            </tbody>

        </table>

    </div>
</template>
