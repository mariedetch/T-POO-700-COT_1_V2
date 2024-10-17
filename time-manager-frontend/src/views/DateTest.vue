<template>
  <flat-pickr v-model="date" :config="config" class="form-control"/>
</template>

<script setup lang="ts">
  import {ref} from 'vue';
  import flatPickr from 'vue-flatpickr-component';
  import 'flatpickr/dist/flatpickr.css';

  const date = ref(null);
  const config = ref({
      enableTime: true,
    dateFormat: 'Y-m-d H:i',
  });
</script>