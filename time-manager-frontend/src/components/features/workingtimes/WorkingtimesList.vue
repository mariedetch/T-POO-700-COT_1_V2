<script setup lang="ts">
import { type Workingtime } from "@/services/workingtimes/types";
import Swal from 'sweetalert2';
import { format } from 'date-fns';

const props = defineProps<{ workingtimes: Workingtime[] }>();
const emit = defineEmits(['editWorkingtime', 'removeWorkingtime'])

const openEditModal = (workingtime: Workingtime) => {
  emit('editWorkingtime', workingtime)
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
  emit('removeWorkingtime', userId)
  }
}
</script>

<template>
  <div class="table-responsive">
    <table class="table table-hover" id="pc-dt-simple">
      <thead>
        <tr>
          <th>#</th>
          <th>Start</th>
          <th>End</th>
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(workingtime, index) in workingtimes" :key="workingtime.id">
          <td>{{ index + 1 }}</td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ format(workingtime.start, 'yyyy-MM-dd HH:mm') }}</h6>
              </div>
            </div>
          </td>
          <td>{{ format(workingtime.end, 'yyyy-MM-dd HH:mm') }}</td>
          <td class="text-center">
            <ul class="flex items-center mr-auto mb-0">
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                  data-pc-toggle="modal"
                  data-pc-target="#customer-edit_add-modal"
                  @click="openEditModal(workingtime)"
                  ><i class="ti ti-edit-circle text-lg leading-none"></i
                ></a>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                  @click="confirmDelete(workingtime.id)"
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