<script setup lang="ts">
import { onMounted } from 'vue';
import { UsersList, UserForm } from '@/components/features/users'
import { useUsersStore } from '@/stores/users';

const userStore = useUsersStore();
const { users, isLoading, error, getUsers, createUser } = userStore;

onMounted(async () => {
  await getUsers();
});

const handleCreateUser = async (userData: any) => {
  try {
    await createUser(userData);
    console.log('Utilisateur créé avec succès');
  } catch (error) {
    console.error('Erreur lors de la création de l\'utilisateur :', error);
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
              data-pc-toggle="modal"
              data-pc-animate="fall"
              data-pc-target="#createUserModal"
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
            <div v-if="isLoading">Chargement en cours...</div>
            <!-- <UsersList :users="users"/> -->

  <div class="table-responsive">
    <table class="table table-hover" id="pc-dt-simple">
      <thead>
        <tr>
          <th>#</th>
          <th>UserName</th>
          <th>Email</th>
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(user, index) in users" :key="user.id">
          <td>{{ index + 1 }}</td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ user.username }}</h6>
              </div>
            </div>
          </td>
          <td>{{ user.email }}</td>
          <td class="text-center">
            <ul class="flex items-center mr-auto mb-0">
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-modal"
                  ><i class="ti ti-eye text-lg leading-none"></i
                ></a>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-edit_add-modal"
                  ><i class="ti ti-edit-circle text-lg leading-none"></i
                ></a>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                  ><i class="ti ti-trash text-lg leading-none"></i
                ></a>
              </li>
            </ul>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
          </div>
        </div>
      </div>
    </div>
    <UserForm :is-loading="isLoading" @submitForm="handleCreateUser" />
  </main>
</template>