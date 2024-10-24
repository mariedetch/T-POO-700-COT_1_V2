<script setup lang="ts">
import { computed } from 'vue';
import Modal from '@/components/shared/Modal.vue';

const props = defineProps({
  workingtime: Object,
  isOpened: Boolean
});

const emit = defineEmits(['close', 'edit', 'delete']);

const formattedDate = computed(() => {
  if (props.workingtime?.start) {
    return new Date(props.workingtime.start).toLocaleDateString();
  }
  return '';
});

const formattedStartTime = computed(() => {
  if (props.workingtime?.start) {
    return new Date(props.workingtime.start).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
  return '';
});

const formattedEndTime = computed(() => {
  if (props.workingtime?.end) {
    return new Date(props.workingtime.end).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
  return '';
});

// function handleEdit() {
//   if (props.workingtime && props.workingtime.id){
//     emit('edit', props.workingtime.id);
//   }
// }


// function handleDelete() {
//   if (props.workingtime && props.workingtime.id) {
//     emit('delete', props.workingtime.id);
//   }
// }

function handleClose() {
  emit('close');
}
</script>

<template>
  <Modal :isOpened="isOpened" modalId="workingtimeDetailModal" modalTitle="Working Time Details">
    <div class="modal-body">
      <div class="event-detail">
        <i class="ti ti-calendar"></i>
        <span>{{ formattedDate }}</span>
      </div>
      <div class="event-detail me_bold">
        <i class="ti ti-clock"></i>
        <span>{{ formattedStartTime }} - {{ formattedEndTime }}</span>
      </div>
      <div class="event-detail">
        <i class="ti ti-notes"></i>
        <span>No comment</span>
      </div>
    </div>
    <div class="modal-footer">
      <button type="button" class="btn btn-outline-primary" @click="handleClose">Close</button>
    </div>
  </Modal>
</template>

<style scoped>

.event-detail {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.event-detail i {
    margin-right: 10px;
    color: #3788d8;
}

.me_bold {
  font-weight: bold;
}
</style>