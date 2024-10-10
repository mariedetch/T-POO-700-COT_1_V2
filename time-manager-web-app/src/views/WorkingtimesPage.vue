<script setup lang="ts">
import { computed, onMounted, ref, toRefs } from 'vue';
import { useRoute } from 'vue-router';
import { WorkingtimesList } from '@/components/features/workingtimes'
import Modal from '@/components/shared/Modal.vue';
import { ToastrService } from '../utils/toastr';
import { type Workingtime } from '../services/workingtimes/types';
import { useWorkingtimesStore } from '@/stores/workingtimes';
import Swal from 'sweetalert2';
import flatPickr from 'vue-flatpickr-component';
import 'flatpickr/dist/flatpickr.css';

const route = useRoute();
const userID = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;

const workingtimeStore = useWorkingtimesStore();
const { workingtimes, isLoading, error, selectedWorkingtime } = toRefs(workingtimeStore);
const isModalOpened = ref(false);

onMounted(async () => {
  await workingtimeStore.getWorkingtimes(userID);
});

const workingtime = computed(() => ({
  start: selectedWorkingtime.value?.start || '',
  end: selectedWorkingtime.value?.end || '',
}));

const modalData = {
  title: 'Add working time',
  button: 'Add'
};

const config = ref({
  enableTime: true,
  dateFormat: 'Y-m-d H:i',
});

const errors = ref({
  start: '',
  end: '',
});

const validateFields = () => {
  errors.value.start = workingtime.value.start ? '' : 'Start time is required.';
  errors.value.end = workingtime.value.end ? '' : 'End time is required.';

  return !errors.value.start && !errors.value.end;
};

const onEditModalOpen = async (workingtime: Workingtime) => {
  selectedWorkingtime.value = workingtime;
  isModalOpened.value = true;

  modalData.title = 'Update working time';
  modalData.button = 'Update';
}

const onCloseModal = async () => {
  isModalOpened.value = false;
  selectedWorkingtime.value = null;
  modalData.title = 'Add working time';
  modalData.button = 'Add';
}

const showDeleteConfirmation = async (workingtimeId: string) => {
  const result = await Swal.fire({
    title: 'Are you sure ?',
    text: "This action could not be canceled !",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Yes, delete',
    cancelButtonText: 'Cancel'
  });

  if (result.isConfirmed) {
    await workingtimeStore.deleteWorkingtime(workingtimeId);
    ToastrService.success('Working time has been deleted');
  }
}

const onSubmit = async () => {
  if (validateFields()) {
    try {
      if (selectedWorkingtime.value) {
        await workingtimeStore.updateWorkingtime(selectedWorkingtime.value.id, {workingtime: workingtime.value});
        selectedWorkingtime.value = null;
        ToastrService.success('Working time has been successfully updated');
      } else {
        await workingtimeStore.createWorkingtime(userID, {workingtime: workingtime.value});
        ToastrService.success('Working time has been successfully created');
      }
    } catch (error) {
      ToastrService.error(`Creation failed ${selectedWorkingtime.value ? 'modification' : 'creation'} of user`)
    } finally {
      onCloseModal()
    }
  }
};
</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item" aria-current="page">Working times</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Working time Management</h2>
          <div class="text-right p-4 pb-sm-2">
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="isModalOpened = true"
            >
              <i class="ti ti-plus f-18"></i> Add working time</a
            >
          </div>
        </div>
      </div>
    </div>
    <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div>
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-body">
            <h3 class="my-5 mx-3">List of working times of</h3>
            <WorkingtimesList @edit-workingtime="onEditModalOpen" @remove-workingtime="showDeleteConfirmation" :workingtimes="workingtimes"/>
          </div>
        </div>
      </div>
    </div>
    <!-- <UserForm :is-loading="isLoading" @submitForm="handleCreateWorkingtime" /> -->
    <Modal :isOpened="isModalOpened" modalId="createWorkingtimeModal" :modalTitle="modalData.title">
      <form @submit.prevent="onSubmit">
        <div class="modal-body">
          <div class="mb-4">
            <label class="form-label" for="start">Start time</label>
            <!-- <input v-model="workingtime.start" type="date" class="form-control" id="start" placeholder="Enter start"> -->
            <flat-pickr v-model="workingtime.start" :config="config" class="form-control"/>

            <small v-if="errors.start" id="start-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_start">{{ errors.start }}</div>
            </small>
          </div>
          <div class="mb-4">
            <label class="form-label" for="end">End time</label>
            <!-- <input v-model="workingtime.end" type="date" class="form-control" id="end" placeholder="Enter end"> -->
            <flat-pickr v-model="workingtime.end" :config="config" class="form-control"/>
            <small v-if="errors.end" id="end-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_end">{{ errors.end }}</div>
            </small>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="onCloseModal()" type="button" class="btn btn-secondary">
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
  </main>
</template>