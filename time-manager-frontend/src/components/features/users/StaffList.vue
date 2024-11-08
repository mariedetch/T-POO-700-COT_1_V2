<script setup lang="ts">
import { type User } from "@/services/users/types";
import { UserRole } from '@/services/auth/types'
import Swal from 'sweetalert2';

const props = defineProps<{ users: User[] }>();
const emit = defineEmits(['editUser', 'removeUser'])

const promoteUser = (user: User) => {
  emit('editUser', user.id)
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
          <th>First Name</th>
          <th>Last Name</th>
          <th>Email</th>
          <th>Role</th>
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(user, index) in users" :key="user.id">
          <td>{{ index + 1 }}</td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ user.firstname }}</h6>
              </div>
            </div>
          </td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ user.lastname }}</h6>
              </div>
            </div>
          </td>
          <td>{{ user.email }}</td>
          <td>
            <span v-if="user.role === UserRole.GENERAL_MANAGER" class="badge text-white text-sm bg-primary-500">G. Manager</span>
            <span v-if="user.role === UserRole.MANAGER" class="badge text-white text-sm bg-success-500">Manager</span>
            <span v-if="user.role === UserRole.EMPLOYEE" class="badge text-white text-sm bg-warning-500">Employee</span>
          </td>
          <td class="text-center">
            <ul class="flex items-center mr-auto mb-0">
              <li class="list-inline-item">
                <RouterLink :to="`calendar/${user.id}`"
                  class="px-4 py-2 rounded-lg inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-modal">
                  <i class="ti ti-calendar-month text-lg leading-none"></i> 
                </RouterLink>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                  @click="confirmDelete(user.id)"
                  ><i class="ti ti-trash text-lg leading-none"></i
                ></a>
              </li>

              <li v-if="user.role === UserRole.EMPLOYEE" class="list-inline-item">
                <a
                  href="#"
                  class="px-4 py-2 bg-gray-200 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-edit_add-modal"
                  @click="promoteUser(user)"
                  >
                  <!-- <i class="ti ti-edit-circle text-lg leading-none"></i> -->
                  <small>
                    Promote
                  </small>
                </a>
              </li>

            </ul>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>