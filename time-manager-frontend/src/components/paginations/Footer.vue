<script setup lang="ts">
const props = defineProps({
  currentPage: { type: Number, default: 1 },
  pageSize: { type: Number, default: 10 },
  totalCount: { type: Number, default: 0 },
  startCount: { type: Number, default: 0 },
  totalPages: { type: Number, default: 0 }
});
const emit = defineEmits(['fetchData'])

const goToPage = (page: number) => {
  if (page >= 1 && page <= props.totalPages) {
    emit('fetchData', page, props.pageSize)
  }
};

const goToPreviousPage = () => {
  if (props.currentPage > 1) {
    emit('fetchData', props.currentPage - 1, props.pageSize)
  }
};

const goToNextPage = () => {
  emit('fetchData', props.currentPage + 1, props.pageSize)
}
</script>

<template>
  <div class="flex justify-between px-5">
    <p>Showing {{ startCount }} to {{ startCount + pageSize }} of {{ totalCount }} entries</p>
    <nav class="datatable-pagination">
      <ul
        class="flex *:*:inline-block *:*:px-3 *:*:py-1.5 *:border *:border-theme-border *:dark:border-themedark-border hover:*:bg-secondary-300/10"
      >
        <!-- Lien pour la page précédente -->
        <li class="ltr:rounded-l-lg rtl:rounded-r-lg">
          <a
            href="#!"
            aria-label="Previous"
            @click.prevent="goToPreviousPage"
            :class="{ 'disabled': currentPage === 1 }"
            :disabled="currentPage === 1"
          >
            <span aria-hidden="true">«</span>
            <span class="sr-only">Previous</span>
          </a>
        </li>

        <!-- Lien pour chaque page -->
        <li v-for="page in totalPages" :key="page" :class="{ 'active': currentPage === page }">
          <a href="#!" @click.prevent="goToPage(page)">{{ page }}</a>
        </li>

        <!-- Lien pour la page suivante -->
        <li class="ltr:rounded-r-lg rtl:rounded-l-lg">
          <a
            href="#!"
            aria-label="Next"
            @click.prevent="goToNextPage"
            :class="{ 'disabled': currentPage === totalPages }"
            :disabled="currentPage === totalPages"
          >
            <span aria-hidden="true">»</span>
            <span class="sr-only">Next</span>
          </a>
        </li>
      </ul>
    </nav>
  </div>
</template>