<script setup lang="ts">
import { ref, watch, computed } from 'vue';
import Modal from '@/components/shared/Modal.vue';

const props = defineProps({
  workingtime: Object,
  isOpened: Boolean
});

const emit = defineEmits(['close', 'submit']);

const formData = ref({
  id: null,
  start: '',
  end: ''
});


watch(() => props.workingtime, (newVal) => {
  if (newVal) {
    if (newVal.id) {
      // Mode édition : utiliser les valeurs existantes
      formData.value = {
        id: newVal.id,
        start: formatDateForInput(newVal.start),
        end: formatDateForInput(newVal.end)
      };
    } else {
      // Mode création : définir les heures par défaut
      const startDate = new Date(newVal.start);
      const endDate = new Date(newVal.start);
      
      startDate.setHours(8, 0, 0, 0);  // 08:00
      endDate.setHours(10, 0, 0, 0);   // 10:00
      
      formData.value = {
        id: null,
        start: formatDateForInput(startDate.toISOString()),
        end: formatDateForInput(endDate.toISOString())
      };
    }
  }
}, { immediate: true, deep: true });

// function formatDateForInput(dateString: string): string {
//   return new Date(dateString).toISOString().slice(0, 16);
// }

// function formatDateForAPI(dateString: string): string {
//   return new Date(dateString).toISOString().slice(0, 19);
// }

function formatDateForInput(dateString: string): string {
  const date = new Date(dateString);
  return date.getFullYear() + '-' +
         String(date.getMonth() + 1).padStart(2, '0') + '-' +
         String(date.getDate()).padStart(2, '0') + 'T' +
         String(date.getHours()).padStart(2, '0') + ':' +
         String(date.getMinutes()).padStart(2, '0');
}

function formatDateForAPI(dateString: string): string {
  const date = new Date(dateString);
  return date.getFullYear() + '-' +
         String(date.getMonth() + 1).padStart(2, '0') + '-' +
         String(date.getDate()).padStart(2, '0') + 'T' +
         String(date.getHours()).padStart(2, '0') + ':' +
         String(date.getMinutes()).padStart(2, '0') + ':' +
         String(date.getSeconds()).padStart(2, '0');
}

function submitForm() {
  const formattedData = {
    workingtime: {
      id: formData.value.id,
      start: formatDateForAPI(formData.value.start),
      end: formatDateForAPI(formData.value.end)
    }
  };
  emit('submit', formattedData);
}

const modalTitle = computed(() => formData.value.id ? 'Edit WorkingTime' : 'Add WorkingTime');
</script>

<template>
  <Modal :isOpened="isOpened" modalId="workingTimeModal" :modalTitle="modalTitle">
    <div class="modal-body">
      <form @submit.prevent="submitForm">
        <input type="hidden" v-model="formData.id">
        <div class="mb-3">
          <label for="start" class="form-label">Start Time:</label>
          <input type="datetime-local" id="start" v-model="formData.start" class="form-control" required>
        </div>
        <div class="mb-3">
          <label for="end" class="form-label">End Time:</label>
          <input type="datetime-local" id="end" v-model="formData.end" class="form-control" required>
        </div>
        <div class="modal-footer">
          <div class="ms-auto">
            <button type="submit" class="btn btn-primary me-2">Save</button>
            <button type="button" class="btn btn-secondary" @click="$emit('close')">Cancel</button>
          </div>
        </div>
      </form>
    </div>
  </Modal>
</template>
