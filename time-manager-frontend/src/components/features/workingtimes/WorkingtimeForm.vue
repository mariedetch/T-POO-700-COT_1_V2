<script setup lang="ts">
import { computed, onMounted, ref, watch, toRefs } from 'vue'
import Modal from '@/components/shared/Modal.vue'
import { useWorkingtimesStore } from '@/stores/workingtimes';
import { ToastrService } from '@/utils/toastr'
import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

const workingtimeStore = useWorkingtimesStore();
const emit = defineEmits(['closeModalForm'])
const props = defineProps({ isModalOpened: Boolean, userID: String })
const errors = ref({ start: '', end: '' })
const config = ref({ enableTime: true, dateFormat: 'Y-m-d H:i' });
const { selectedWorkingtime, isLoading } = toRefs(workingtimeStore)

const workingtime = computed(() => ({
  start: selectedWorkingtime.value?.start || '',
  end: selectedWorkingtime.value?.end || '',
}))

const modalData = computed(() => ({
  title: selectedWorkingtime.value ? `Update a working time` : 'Add new user',
  button: selectedWorkingtime.value ? 'Update' : 'Add'
}))

const update = async (id: string) => {
  if (await workingtimeStore.updateWorkingtime(id, { workingtime: workingtime.value })) {
    selectedWorkingtime.value = null
    ToastrService.success('Working time has been successfully updated')
  }
}

const create = async () => {
  if (await workingtimeStore.createWorkingtime(props.userID || '', { workingtime: workingtime.value })) {
    ToastrService.success('Working time has been successfully created')
  }
}

const onSubmit = async () => {
  // if (validateFields()) {
    if (selectedWorkingtime.value) {
      await update(selectedWorkingtime.value.id)
    } else {
      await create()
    }

    emit('closeModalForm')
  // }
}

</script>

<template>
  <Modal :isOpened="isModalOpened" modalId="createWorkingtimeModal" :modalTitle="modalData.title">
    <form @submit.prevent="onSubmit">
      <div class="modal-body">
        <div class="mb-4">
          <label class="form-label" for="start">Start time</label>
          <flat-pickr v-model="workingtime.start" :config="config" class="form-control" id="start" placeholder="Enter start"/>

          <small v-if="errors.start" id="start-error-msg" class="form-text">
            <div class="error-message" id="bouncer-error_start">{{ errors.start }}</div>
          </small>
        </div>
        <div class="mb-4">
          <label class="form-label" for="end">End time</label>
          <flat-pickr v-model="workingtime.end" :config="config" class="form-control" id="end" placeholder="Enter end"/>
          <small v-if="errors.end" id="end-error-msg" class="form-text">
            <div class="error-message" id="bouncer-error_end">{{ errors.end }}</div>
          </small>
        </div>
      </div>
      <div class="modal-footer">
        <button @click="emit('closeModalForm')" type="button" class="btn btn-secondary">
          Close
        </button>
        <button v-if="isLoading" class="btn btn-primary lh-1 inline-flex items-center gap-3 disabled" type="button" disabled="disabled">
          <span class="flex border-[2px] border-white-500 rounded-full size-4 animate-spin border-l-transparent dark:border-l-transparent" role="status">
            <span class="sr-only">Loading...</span>
          </span>
          Loading...
        </button>
        <button v-else type="submit" class="btn btn-primary ltr:ml-2 trl:mr-2">{{ modalData.button }}</button>
      </div>
    </form>
  </Modal>
</template>