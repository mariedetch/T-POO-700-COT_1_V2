<script setup lang="ts">
const props = defineProps({
  modalId: String,
  modalTitle: String
})
const formatedModalId = "#" + props.modalId
</script>

<template>
  <div
    :id="modalId"
    class="modal fade"
    role="dialog"
    aria-labelledby="{{ modalId }}Label"
  >
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ modalTitle }}</h5>
          <button
            :data-pc-modal-dismiss="formatedModalId"
            class="text-lg flex items-center justify-center rounded w-7 h-7 text-secondary-500 hover:bg-danger-500/10 hover:text-danger-500"
          >
            <i class="ti ti-x"></i>
          </button>
        </div>
        <slot></slot>
      </div>
    </div>
  </div>
</template>