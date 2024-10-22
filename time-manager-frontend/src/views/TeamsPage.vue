<script setup lang="ts">
import All_Teams_List from '../components/features/teams/All_Teams_List.vue';

// List All Teams Page permet de lister absolument toutes les équipes de l'entreprise
// Cette view utile le component All_Teams_List.vue qui affiche juste les équipes 
</script>

<template>
    <main>
      <div class="page-header">
        <div class="page-block">
          <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
            <li class="breadcrumb-item" aria-current="page">All Teams</li>
          </ul>
          <div class="page-header-title flex flex-row justify-between items-center">
            <h2 class="mb-0">Team management</h2>
          </div>
        </div>
      </div>
      <!-- <div v-if="error" class="alert alert-danger" role="alert">{{ error }}</div> -->
      <div class="grid grid-cols-12 gap-6">
        <div class="col-span-12">
          <div class="card table-card">
            <div class="card-header flex items-center justify-between">
              <h3>List of all teams</h3>
            </div>
            <div class="card-body">
                <All_Teams_List/>
            </div>
          </div>
        </div>
      </div>
  

    </main>
  </template>