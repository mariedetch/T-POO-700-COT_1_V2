<script setup lang="ts">
import Modal from '@/components/shared/Modal.vue';
</script>

<template>
  <Modal modalId="createUserModal" modalTitle="Add a new user">
    <form action="" method="post">
      <div class="modal-body">
        <div class="mb-4">
          <label class="form-label" for="email">Email address</label>
          <input type="email" class="form-control" id="email" placeholder="Enter email">
        </div>
        <div class="mb-4">
          <label class="form-label" for="username">Username</label>
          <input type="text" class="form-control" id="username" placeholder="Enter username">
        </div>
        <div class="mb-4">
          <label class="form-label" for="exampleFormControlSelect1">Select a Role</label>
          <select class="form-select" id="exampleFormControlSelect1">
            <option>Manager</option>
            <option>Employee</option>
          </select>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-pc-modal-dismiss="#createUserModal">
          Close
        </button>
        <button type="button" class="btn btn-primary ltr:ml-2 trl:mr-2">Ajouter</button>
      </div>
    </form>
  </Modal>
</template>