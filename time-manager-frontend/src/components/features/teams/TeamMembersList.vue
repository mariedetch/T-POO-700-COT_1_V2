<script setup lang="ts">
import { type User } from "@/services/users/types";
import Swal from 'sweetalert2';

const props = defineProps<{ users: User[] }>();
const emit = defineEmits(['editUser', 'removeUser'])

const openEditModal = (user: User) => {
  emit('editUser', user)
}

const confirmDelete = async (userId: string) => {
  const result = await Swal.fire({
    title: 'Êtes-vous sûr ?',
    text: 'Cette action ne peut pas être annulée !',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Oui, supprimer',
    cancelButtonText: 'Annuler'
  })

  if (result.isConfirmed) {
  emit('removeUser', userId)
  }
}
</script>

<template>
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
                <RouterLink :to="`/workingtimes/${user.id}`"
                  class="px-4 py-2 bg-gray-200 rounded-lg inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-modal">
                  <small>
                    Workingtimes
                  </small><!-- <i class="ti ti-eye text-lg leading-none"></i> -->
                </RouterLink>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-edit_add-modal"
                  @click="openEditModal(user)"
                  ><i class="ti ti-edit-circle text-lg leading-none"></i
                ></a>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                  @click="confirmDelete(user.id)"
                  ><i class="ti ti-trash text-lg leading-none"></i
                ></a>
              </li>
            </ul>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>