<script setup lang="ts">
import { ref, onMounted, toRefs } from 'vue'
import { Form, Field, ErrorMessage } from 'vee-validate'
import Multiselect from 'vue-multiselect'
import userService from '@/services/users'
import { UserRole } from '@/services/auth/types'
import Modal from '@/components/shared/Modal.vue'
import { useTeamsStore } from '@/stores/teams'
import type { User } from '@/services/users/types'
import { ToastrService } from '@/utils/toastr'

const emit = defineEmits(['closeModalForm']),
  props = defineProps({ isModalOpened: Boolean, userRole: { type: String, default: ''} }),
  teamStore = useTeamsStore(),
  { isLoading } = toRefs(teamStore),
  selectedEmployees = ref<User[]>([]),
  employees = ref<User[]>([]),
  managers = ref<User[]>([]),
  isSearchLoading = ref<boolean>(false),
  selectedManager = ref<User|null>(null),
  error = ref(''),
  teamData = {
    name: '',
    description: '',
    manager_id: '',
    user_ids: []
  };

const nameWithLang = (user: User) => {
  return `${user.firstname} ${user.lastname}`
}

const limitText = (count: any) => {
  return `and ${count} other employees`
}
const asyncFind = (query: any) => {
  isSearchLoading.value = true
  userService.getUsersByRoleAndName(UserRole.EMPLOYEE).then((response) => {
    employees.value = response.data.data
    isSearchLoading.value = false
    console.log(employees.value)
  })
}
const clearAll = () => {
  selectedEmployees.value = []
}

onMounted(async () => {
  managers.value = (await userService.getUsersByRoleAndName(UserRole.MANAGER)).data.data
})

const onSubmit = async () => {
  if (!selectedManager.value && props.userRole === UserRole.GENERAL_MANAGER) {
    error.value = 'Please select the manager of the team'
  } else {
    teamData.manager_id = selectedManager.value?.id;
    selectedEmployees.value.forEach(element => {
      teamData.user_ids.push(element.id as string)
    });
    if (await teamStore.createTeam({ team: teamData })) {
      ToastrService.success('Team created successfully')
      emit('closeModalForm')
    } else {
      ToastrService.error('Error while creating a team')
    }
  }
}
</script>

<template>
  <Modal :isOpened="isModalOpened" modalId="createTeamModal" modalTitle="Create a Team">
    <Form @submit="onSubmit">
      <div class="modal-body">
        <div class="mb-3">
          <label class="form-label">Team Name</label>
          <Field
            type="text"
            v-model="teamData.name"
            name="name"
            class="form-control"
            placeholder="Team Name"
            rules="required"
          />
          <ErrorMessage name="name" class="error-message" />
        </div>
        <div class="mb-3">
          <label class="form-label">Description</label>
          <Field
            as="textarea"
            name="description"
            v-model="teamData.description"
            class="form-control"
            rows="2"
            rules="required"
            placeholder="Tapez votre description ici..."
          />
          <ErrorMessage name="description" class="error-message" />
          <!-- v-slot="{ field, errors, meta }"
            :class="{ 'border-red-500': meta.touched && errors.length } -->
        </div>
        <div class="mb-3" v-if="userRole === 'GENERAL_MANAGER'">
          <div>
            <label class="form-label" for="multiselect">Select a Manager</label>
            <multiselect
              v-model="selectedManager"
              :options="managers"
              :custom-label="nameWithLang"
              placeholder="Select one"
              label="email"
              track-by="email"
            ></multiselect>
            <span class="error-message">{{ error }}</span>
          </div>
        </div>
        <div class="mb-3">
          <div>
            <label class="form-label" for="ajax">Select a members</label>
            <multiselect
              v-model="selectedEmployees"
              id="ajax"
              label="firstname"
              track-by="id"
              placeholder="Type to search"
              open-direction="bottom"
              :options="employees"
              :multiple="true"
              :searchable="true"
              :loading="isSearchLoading"
              :internal-search="true"
              :clear-on-select="false"
              :close-on-select="false"
              :options-limit="300"
              :limit="3"
              :limit-text="limitText"
              :max-height="600"
              :show-no-results="false"
              :hide-selected="true"
              @search-change="asyncFind"
            >
              <template #tag="{ option, remove }"
                ><span class="custom__tag"
                  ><span>{{ option.firstname + ' ' + option.lastname }}</span
                  ><span class="custom__remove" @click="remove(option)">❌</span></span
                ></template
              >
              <template>
                <div
                  class="multiselect__clear"
                  v-if="selectedEmployees.length"
                  @mousedown.prevent.stop="clearAll()"
                ></div>
              </template>
              <template #noResult>
                <span>Oops! No elements found. Consider changing the search query.</span>
              </template>
            </multiselect>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button @click="emit('closeModalForm')" type="button" class="btn btn-secondary">
          Close
        </button>
        <button
          v-if="isLoading"
          class="btn btn-primary lh-1 inline-flex items-center gap-3 disabled"
          type="button"
          :disabled="true"
        >
          <span
            class="flex border-[2px] border-white-500 rounded-full size-4 animate-spin border-l-transparent dark:border-l-transparent"
            role="status"
          >
            <span class="sr-only">Loading...</span>
          </span>
          Loading...
        </button>
        <button v-else type="submit" class="btn btn-primary ltr:ml-2 trl:mr-2">Submit</button>
      </div>
    </Form>
  </Modal>
</template>

<style>
@import 'vue-multiselect/dist/vue-multiselect.min.css';
</style>

<style>
.custom__tag {
  display: inline-block;
  padding: 3px 12px;
  background: #d2d7ff;
  margin-right: 8px;
  margin-bottom: 8px;
  border-radius: 10px;
  cursor: pointer;
}
</style>