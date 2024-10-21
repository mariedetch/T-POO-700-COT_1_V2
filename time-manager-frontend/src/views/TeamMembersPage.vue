<script setup lang="ts">
import { onMounted, ref, toRefs } from 'vue'
import { UserForm } from '@/components/features/users'
import TeamMembersList from '../components/features/teams/TeamMembersList.vue'
import { useUsersStore } from '@/stores/users'
import { ToastrService } from '../utils/toastr'
import { type User } from '../services/users/types'

const userStore = useUsersStore()
const { users, error, selectedUser } = toRefs(userStore)
const filterData = { username: null, email: null }
const isUserFormOpened = ref(false)

const onModalOpen = async (user: User | null = null) => {
  selectedUser.value = user
  isUserFormOpened.value = true
}

const onCloseModal = async () => {
  isUserFormOpened.value = false
  selectedUser.value = null
}

const onDeleted = async (userId: string) => {
  if (await userStore.deleteUser(userId)) {
    ToastrService.success("L'utilisateur a été supprimé.");
  }
}

const onFiltered = async () => { 
  await userStore.getUsers(filterData.email, filterData.username)
}

onMounted(async () => {
  await userStore.getUsers()
})

</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item"><router-link to="/teams">My teams</router-link></li>
          <li class="breadcrumb-item" aria-current="page">Team Members</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Team : {Name}</h2>
          <div class="text-right p-4 pb-sm-2">
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="onModalOpen()"
            >
              <i class="ti ti-plus f-18"></i> Add User</a
            >
          </div>
        </div>
      </div>
    </div>
    <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div>
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-header flex items-center justify-between">
            <h3>List of team Members</h3>
            <div class="flex sm:flex-col gap-2">
              <input
                v-model="filterData.email"
                @blur="onFiltered()"
                class="datatable-input"
                placeholder="Search by email..."
                type="search"
                name="email"
              />
              <input
                v-model="filterData.username"
                @blur="onFiltered()"
                class="datatable-input"
                placeholder="Search by username..."
                type="search"
                name="username"
              />
            </div>
          </div>
          <div class="card-body">
            <TeamMembersList
              @edit-user="onModalOpen"
              @remove-user="onDeleted"
              :users="users"
            />
          </div>
        </div>
      </div>
    </div>

    <UserForm :is-modal-opened="isUserFormOpened" @close-modal-form="onCloseModal"/>
  </main>
</template>