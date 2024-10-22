<script setup lang="ts">
import EmployeeList from '@/components/features/users/EmployeeList.vue';

// List Teams Page permet de lister toutes les équipes d'un manager
// Cette view utile le component TeamsList.vue qui affiche juste les équipes
</script>

<template>
    <main>
      <div class="page-header">
        <div class="page-block">
          <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
            <li class="breadcrumb-item" aria-current="page">All employees</li>
          </ul>
          <div class="page-header-title flex flex-row justify-between items-center">
            <h2 class="mb-0">Employee management</h2>
          </div>
        </div>
      </div>
      <!-- <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div> -->
      <div class="grid grid-cols-12 gap-6">
        <div class="col-span-12">
          <div class="card table-card">
            <div class="card-header flex items-center justify-between">
              <h3>List of all employees</h3>
            </div>
            <div class="card-body">
                <EmployeeList/>
            </div>
          </div>
        </div>
      </div>


    </main>
  </template>