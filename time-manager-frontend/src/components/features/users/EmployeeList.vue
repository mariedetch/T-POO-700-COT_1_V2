<script setup lang="ts">
import { useUsersStore } from '@/stores/users'
import { onMounted, toRefs } from 'vue'

const userStore = useUsersStore()
const { employees } = toRefs(userStore)

onMounted(async () => {
  await userStore.getEmployees()
})
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
          <th>Tel</th>
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(employee, index) in employees" :key="employee.id">
          <td>{{ index + 1 }}</td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ employee.firstname }}</h6>
              </div>
            </div>
          </td>
          <td>
            <div class="flex items-center">
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ employee.lastname }}</h6>
              </div>
            </div>
          </td>
          <td>{{ employee.email }}</td>
          <td>{{ employee.tel }}</td>
          <td>
            <ul class="flex items-center mr-auto mb-0">
              <li class="list-inline-item">
                <RouterLink
                  :to="`/dashboard/${employee.id}`"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                >
                  <i class="ti ti-calendar-clock text-lg leading-none"></i>
                </RouterLink>
              </li>
              <li class="list-inline-item">
                <a
                  href="#"
                  class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                >
                  <i class="ti ti-layout-dashboard text-lg leading-none"></i>
                </a>
              </li>
            </ul>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>