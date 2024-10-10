<script setup lang="ts">
import { useClocksStore } from '@/stores/clocks';
import { computed, toRefs } from 'vue';
import { ToastrService } from '../../../utils/toastr';

const clockStore = useClocksStore();
const { startDateTime, clockIn, error } = toRefs(clockStore);

const data = computed(() => ({
  checked: (clockIn.value ? 'checked' : '') as string,
  message: (startDateTime.value ? `Démarrer à ${startDateTime.value}` : 'Marquez votre arrivée'),
}));

const onClock = async () => {
  try {
    await clockStore.clock();
    ToastrService.success(`Vous avez marquer votre ${clockIn ? 'arrivée' : 'sortie'} avec succès`)
  } catch (error) {
    ToastrService.error('Echec lors du clock! veuillez reéssayer ultérieurement')
  }
};

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
