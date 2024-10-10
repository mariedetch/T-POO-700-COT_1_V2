<script setup lang="ts">
import { computed, onMounted, ref, toRefs } from 'vue';
import { UsersList } from '@/components/features/users'
import { useUsersStore } from '@/stores/users';
import Modal from '@/components/shared/Modal.vue';
import { ToastrService } from '../utils/toastr';
import { type User } from '../services/users/types';

const userStore = useUsersStore();
const { users, error, isLoading, selectedUser } = toRefs(userStore);
const isModalOpened = ref(false);

onMounted(async () => {
  await userStore.getUsers();
});

const user = computed(() => ({
  username: selectedUser.value?.username || '',
  email: selectedUser.value?.email || '',
}));

const errors = ref({
  username: '',
  email: '',
});

const validateFields = () => {
  errors.value.username = user.value.username ? '' : 'Le nom est requis.';
  errors.value.email = user.value.email
    ? (/\S+@\S+\.\S+/.test(user.value.email as string) ? '' : 'L\'email est invalide.')
    : 'L\'email est requis.';

  return !errors.value.username && !errors.value.email;
};

const onEditModalOpen = async (user: User) => {
  selectedUser.value = user;
  isModalOpened.value = true;
}

const onSubmit = async () => {
  if (validateFields()) {
    try {
      await userStore.createUser({user: user.value});
      ToastrService.success('Utilisateur créé avec succès')
      console.log('Utilisateur créé avec succès');
    } catch (error) {
      ToastrService.error('Echec de création de l\'utilisateur')
    } finally {
      isModalOpened.value = false
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
          <li class="breadcrumb-item" aria-current="page">Users</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">User Management</h2>
          <div class="text-right p-4 pb-sm-2">
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="isModalOpened = true"
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
          <div class="card-body">
            <h3 class="my-5 mx-3">List of users</h3>
            <UsersList @edit-user="onEditModalOpen" :users="users"/>
          </div>
        </div>
      </div>
    </div>
    <!-- <UserForm :is-modal-open="isModalOpened" :is-loading="isLoading" @submitForm="handleCreateUser" /> -->

    <Modal :isOpened="isModalOpened" modalId="createUserModal" modalTitle="Add a new user">
      <form @submit.prevent="onSubmit">
        <div class="modal-body">
          <div class="mb-4">
            <label class="form-label" for="email">Email address</label>
            <input v-model="user.email" type="email" class="form-control" id="email" placeholder="Enter email">
            <small v-if="errors.email" id="email-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_email">{{ errors.email }}</div>
            </small>
          </div>
          <div class="mb-4">
            <label class="form-label" for="username">Username</label>
            <input v-model="user.username" type="text" class="form-control" id="username" placeholder="Enter username">
            <small v-if="errors.username" id="username-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_username">{{ errors.username }}</div>
            </small>
          </div>
        </div>
        <div class="modal-footer">
          <button @click="isModalOpened = false" type="button" class="btn btn-secondary">
            Close
          </button>
          <button v-if="isLoading" class="btn btn-primary lh-1 inline-flex items-center gap-3 disabled" type="button" disabled="disabled">
            <span class="flex border-[2px] border-white-500 rounded-full size-4 animate-spin border-l-transparent dark:border-l-transparent" role="status">
              <span class="sr-only">Loading...</span>
            </span>
            Loading...
          </button>
          <button v-else type="submit" class="btn btn-primary ltr:ml-2 trl:mr-2">Ajouter</button>
        </div>
      </form>
    </Modal>
  </main>
</template>