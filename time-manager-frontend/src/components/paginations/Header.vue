<script setup lang="ts">
const props = defineProps({
  currentPage: { type: Number, default: 1 },
  pageSize: { type: Number, default: 10 }
});
</script>

<template>
  <div class="datatable-top my-5">
    <div class="datatable-dropdown">
      <label><!--  -->
        <select class="datatable-selector" name="per-page">
          <option value="10" :selected="pageSize == 10">10</option>
          <option value="20" :selected="pageSize == 20">20</option>
          <option value="50" :selected="pageSize == 50">50</option>
        </select>
        entries per page
      </label>
    </div>
    <div class="datatable-search">
      <input
        class="datatable-input"
        placeholder="Search..."
        type="search"
        name="search"
        title="Search within table"
        aria-controls="pc-dt-simple"
      />
    </div>
  </div>
</template>