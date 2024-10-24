<script setup lang="ts">
import EmployeeDashboard from '../components/features/dashboard/EmployeeDashboard.vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const userId = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;

</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item" aria-current="page">Dashboard</li>
        </ul>
        <div class="page-header-title"><h2 class="mb-0">Dashboard</h2></div>
      </div>
    </div>
    <EmployeeDashboard :userId="userId" />
  </main>
</template>