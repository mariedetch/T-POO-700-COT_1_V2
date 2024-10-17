<script setup lang="ts">
import Navbar from '@/components/layouts/Navbar.vue'
import Footer from '@/components/layouts/Footer.vue'
import Sidebar from '@/components/layouts/Sidebar.vue'
</script>

<template>
  <main>
    <Navbar />
    <Sidebar />
    <div class="pc-container">
      <div class="pc-content">
        <RouterView />
      </div>
    </div>
    <Footer />
  </main>
</template>
