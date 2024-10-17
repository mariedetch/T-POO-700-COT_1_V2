<script setup lang="ts">
import { useClocksStore } from '@/stores/clocks';
import { computed, onMounted, ref, toRefs } from 'vue';
import { ToastrService } from '../../../utils/toastr';

const clockStore = useClocksStore();
const { startDateTime, clockIn, error } = toRefs(clockStore);

const data = computed(() => ({
  checked: (clockIn.value ? 'checked' : '') as string,
  message: (startDateTime.value ? `Démarrer il y a ${formattedElapsedTime.value}` : 'Marquez votre arrivée'),
}));

const elapsedTime = ref(0);
const formattedElapsedTime = ref("");

const formatElapsedTime = (time: number) => {
  const seconds = Math.floor((time / 1000) % 60);
  const minutes = Math.floor((time / (1000 * 60)) % 60);
  const hours = Math.floor((time / (1000 * 60 * 60)) % 24);
  const days = Math.floor(time / (1000 * 60 * 60 * 24));

  const timeParts = [];

  if (days > 0) timeParts.push(`${days} jrs`);
  if (hours > 0) timeParts.push(`${hours}h`);
  if (minutes > 0) timeParts.push(`${minutes}m`);
  if (seconds > 0 || timeParts.length === 0) timeParts.push(`${seconds}s`);

  return timeParts.join(' ');
};

const updateElapsedTime = () => {
  const now = new Date().getTime();
  elapsedTime.value = now - (startDateTime.value ? (new Date(startDateTime.value)).getTime() : new Date().getTime()); // Calculer le temps écoulé
  formattedElapsedTime.value = formatElapsedTime(elapsedTime.value);
};

const onClock = async () => {
  try {
    await clockStore.clock();
    ToastrService.success(`Clock effectué avec succès`)
  } catch (error) {
    ToastrService.error('Echec lors du clock! veuillez reéssayer ultérieurement')
  }
};

onMounted(async () => {
  await clockStore.getLatestClock();
  updateElapsedTime();
  setInterval(updateElapsedTime, 1000);
});

</script>

<template>
  <li class="pc-h-item">
    <div class="card pc-user-card bg-theme-sidebaruserbg dark:bg-themedark-sidebaruserbg mb-0">
      <div class="card-body" style="padding: 10px !important">
        <div class="form-check form-switch custom-switch-v1 !inline-flex mr-2">
          <input
            type="checkbox"
            class="form-check-input input-primary"
            id="customCheckinl4"
            v-model="clockIn"
            @change="onClock"
          />
          <label class="form-check-label" for="customCheckinl4">{{ data.message }}</label>
        </div>
      </div>
    </div>
  </li>
</template>
