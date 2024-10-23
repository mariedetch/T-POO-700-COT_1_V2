<script setup lang="ts">
import TeamsList from '@/components/features/teams/TeamsList.vue'
import CreateTeamForm from '@/components/features/teams/CreateTeamForm.vue'
import { ref, toRefs } from 'vue';
import { useAuthStore } from '@/stores/auth';

const authStore = useAuthStore();
const { authUser } = toRefs(authStore);
const isFormOpened = ref(false)

const onModalOpen = async () => {
  isFormOpened.value = true
}

const onCloseModal = async () => {
  isFormOpened.value = false
}
</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item" aria-current="page">All Teams</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Team management</h2>
          <div class="text-right p-4 pb-sm-2">
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="onModalOpen()"
            >
              <i class="ti ti-plus f-18"></i> Create a Team</a
            >
          </div>
        </div>
      </div>
    </div>
    <!-- <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div> -->
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-header flex items-center justify-between">
            <h3>List of all teams</h3>
          </div>
          <div class="card-body">
            <TeamsList :userRole="authUser.role"/>
          </div>
        </div>
      </div>
    </div>
    <CreateTeamForm :userRole="authUser.role" :isModalOpened="isFormOpened" @close-modal-form="onCloseModal"/>
  </main>
</template>