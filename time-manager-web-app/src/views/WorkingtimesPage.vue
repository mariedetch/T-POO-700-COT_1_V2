<script setup lang="ts">
import { onMounted, ref, toRefs } from 'vue';
import { useRoute } from 'vue-router';
import { WorkingtimesList, WorkingtimeForm } from '@/components/features/workingtimes'
import { ToastrService } from '../utils/toastr';
import { type Workingtime } from '../services/workingtimes/types';
import { useWorkingtimesStore } from '@/stores/workingtimes';

const route = useRoute();
const userID = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;

const workingtimeStore = useWorkingtimesStore();
const { workingtimes, error, selectedWorkingtime } = toRefs(workingtimeStore);
const isFormOpened = ref(false);

const onEditModalOpen = async (workingtime: Workingtime) => {
  selectedWorkingtime.value = workingtime;
  isFormOpened.value = true;
}

const onCloseModal = async () => {
  isFormOpened.value = false;
  selectedWorkingtime.value = null;
}

const deleteWorkingtime = async (workingtimeId: string) => {
  if (await workingtimeStore.deleteWorkingtime(workingtimeId)) {
    ToastrService.success('Working time has been deleted');
  }
}

onMounted(async () => {
  await workingtimeStore.getWorkingtimes(userID);
});
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
              @click="isFormOpened = true"
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
            <WorkingtimesList @edit-workingtime="onEditModalOpen" @remove-workingtime="deleteWorkingtime" :workingtimes="workingtimes"/>
          </div>
        </div>
      </div>
    </div>
    <WorkingtimeForm :is-modal-opened="isFormOpened" :userID="userID" @close-modal-form="onCloseModal"/>
  </main>
</template>