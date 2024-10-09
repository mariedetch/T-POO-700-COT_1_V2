<script setup lang="ts">
import { UsersList, UserForm } from '@/components/features/users'
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
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-body">
            <h3 class="my-5 mx-3">List of users</h3>
            <UsersList />
          </div>
        </div>
      </div>
    </div>
    <UserForm />
  </main>
</template>