<script setup lang="ts">
import TeamsList from '../components/features/teams/TeamsList.vue';

// List Teams Page permet de lister toutes les équipes d'un manager
// Cette view utile le component TeamsList.vue qui affiche juste les équipes 
</script>

<template>
    <main>
      <div class="page-header">
        <div class="page-block">
          <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
            <li class="breadcrumb-item" aria-current="page">My teams</li>
          </ul>
          <div class="page-header-title flex flex-row justify-between items-center">
            <h2 class="mb-0">Teams Management</h2>
            <div class="text-right p-4 pb-sm-2">
            <!-- <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
              @click="onModalOpen()"
            > -->
            <a
              href="#"
              class="btn btn-primary d-inline-flex align-items-center gap-2"
            >
              <i class="ti ti-plus f-18"></i>Create Team</a
            >
          </div>
          </div>
        </div>
      </div>
      <!-- <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div> -->
      <div class="grid grid-cols-12 gap-6">
        <div class="col-span-12">
          <div class="card table-card">
            <div class="card-header flex items-center justify-between">
              <h3>List of my teams</h3>
            </div>
            <div class="card-body">
                <TeamsList/>
            </div>
          </div>
        </div>
      </div>
  

    </main>
  </template>