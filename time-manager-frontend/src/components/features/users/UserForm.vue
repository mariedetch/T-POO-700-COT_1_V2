<script setup lang="ts">
import { computed, onMounted, ref, watch, toRefs } from 'vue'
import Modal from '@/components/shared/Modal.vue'
import { useUsersStore } from '@/stores/users'
import { ToastrService } from '@/utils/toastr'
import { Form, Field, ErrorMessage } from 'vee-validate'

const userStore = useUsersStore()

const emit = defineEmits(['closeModalForm'])
const props = defineProps({ isModalOpened: Boolean })
const { selectedUser, isLoading } = toRefs(userStore)

const user = computed(() => ({
  firstname: selectedUser.value?.firstname || '',
  lastname: selectedUser.value?.lastname || '',
  email: selectedUser.value?.email || '',
  role: selectedUser.value?.role || ''
}))
const modalData = computed(() => ({
  title: selectedUser.value ? `Update user ${selectedUser.value.firstname}` : 'Add new user',
  button: selectedUser.value ? 'Update' : 'Add'
}))

const updateUser = async (userId: string) => {
  if (await userStore.updateUser(userId, { user: user.value })) {
    selectedUser.value = null
    ToastrService.success('Utilisateur mise à jour avec succès')
  }
}

const createUser = async () => {
  if (await userStore.createUser({ user: user.value })) {
    ToastrService.success('Utilisateur crée avec succès')
  }
}

const onSubmit = async () => {
    if (selectedUser.value) {
      await updateUser(selectedUser.value.id)
    } else {
      await createUser()
    }
    emit('closeModalForm')
}

</script>

<template>
  <main>
    <Modal :isOpened="isModalOpened" modalId="createUserModal" :modalTitle="modalData.title">
      <Form @submit="onSubmit">
        <div class="modal-body">
          <div class="mb-4">
            <label class="form-label" for="firstname">Firstname</label>
            <Field
              v-model="user.firstname"
              type="text"
              class="form-control"
              id="firstname"
              name="firstname"
              placeholder="Enter firstname"
              rules="required|min:3"
            />
            <ErrorMessage name="firstname" class="error-message" />
          </div>
          <div class="mb-4">
            <label class="form-label" for="lastname">Lastname</label>
            <Field
              v-model="user.lastname"
              type="text"
              class="form-control"
              id="lastname"
              name="lastname"
              placeholder="Enter lastname"
              rules="required|min:3"
            />
            <ErrorMessage name="lastname" class="error-message" />
          </div>
          <div class="mb-4">
            <label class="form-label" for="email">Email</label>
            <Field
              v-model="user.email"
              type="email"
              class="form-control"
              id="lastname"
              name="email"
              placeholder="Enter email"
              rules="required|email"
            />
            <ErrorMessage name="email" class="error-message" />
          </div>
          <div class="mb-4">
            <label class="form-label" for="role">Role</label>
            <Field
              v-model="user.role"
              as="select"
              name="role"
              id="role"
              class="form-select"
              rules="required">
              <option v-if="user.role == null" value="">Select a role</option>
              <option value="EMPLOYEE">Employee</option>
              <option value="MANAGER">Manager</option>
            </Field>
            <ErrorMessage name="role" class="error-message" />
          </div>
        </div>
        <div class="modal-footer">
          <button @click="emit('closeModalForm')" type="button" class="btn btn-secondary">Close</button>
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
          <button v-else type="submit" class="btn btn-primary ltr:ml-2 trl:mr-2">
            {{ modalData.button }}
          </button>
        </div>
      </Form>
    </Modal>
  </main>
</template>