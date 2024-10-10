<script setup lang="ts">
import Modal from '@/components/shared/Modal.vue';
import { ref } from 'vue';

const emit = defineEmits(['submitForm'])
const props = defineProps<{
  isLoading: boolean,
}>();

const user = ref({
  username: '',
  email: '',
});

const errors = ref({
  username: '',
  email: '',
});

const validateFields = () => {
  errors.value.username = user.value.username ? '' : 'Le nom est requis.';
  errors.value.email = user.value.email 
    ? (/\S+@\S+\.\S+/.test(user.value.email) ? '' : 'L\'email est invalide.')
    : 'L\'email est requis.';

  return !errors.value.username && !errors.value.email;
};

const onSubmit = () => {
  if (validateFields()) {
    emit('submitForm', { user: user.value});
  }
};

</script>

<template>
  <Modal modalId="createUserModal" modalTitle="Add a new user">
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
        <button type="button" class="btn btn-secondary" data-pc-modal-dismiss="#createUserModal">
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
</template>