<script setup lang="ts">
import { computed, onMounted, ref, watch, toRefs } from 'vue'
import Modal from '@/components/shared/Modal.vue'
import { useUsersStore } from '@/stores/users'
import { ToastrService } from '@/utils/toastr'

const userStore = useUsersStore()

const emit = defineEmits(['closeModalForm'])
const props = defineProps({ isModalOpened: Boolean })
const { selectedUser, isLoading } = toRefs(userStore)

const user = computed(() => ({
  username: selectedUser.value?.username || '',
  email: selectedUser.value?.email || ''
}))
const modalData = computed(() => ({
  title: selectedUser.value ? `Update user ${selectedUser.value.username}` : 'Add new user',
  button: selectedUser.value ? 'Update' : 'Add'
}))

const errors = ref({
  username: '',
  email: ''
})

const updateUser = async (userId: string) => {
  if (await userStore.updateUser(userId, { user: user.value })) {
    selectedUser.value = null
    ToastrService.success('Utilisateur mise à jour avec succès')
  }
}

const createUser = async () => {
  if (await userStore.createUser({ user: user.value })) {
    ToastrService.success('Utilisateur mise à jour avec succès')
  }
}

const onSubmit = async () => {
  // if (validateFields()) {
    if (selectedUser.value) {
      await updateUser(selectedUser.value.id)
    } else {
      await createUser()
    }

    emit('closeModalForm')
  // }
}

</script>

<template>
  <main>
    <Modal :isOpened="isModalOpened" modalId="createUserModal" :modalTitle="modalData.title">
      <form @submit.prevent="onSubmit">
        <div class="modal-body">
          <div class="mb-4">
            <label class="form-label" for="email">Email address</label>
            <input
              v-model="user.email"
              type="email"
              class="form-control"
              id="email"
              placeholder="Enter email"
            />
            <small v-if="errors.email" id="email-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_email">{{ errors.email }}</div>
            </small>
          </div>
          <div class="mb-4">
            <label class="form-label" for="username">Username</label>
            <input
              v-model="user.username"
              type="text"
              class="form-control"
              id="username"
              placeholder="Enter username"
            />
            <small v-if="errors.username" id="username-error-msg" class="form-text">
              <div class="error-message" id="bouncer-error_username">{{ errors.username }}</div>
            </small>
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
      </form>
    </Modal>
  </main>
</template>