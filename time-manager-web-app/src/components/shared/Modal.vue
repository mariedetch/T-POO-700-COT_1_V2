<script setup lang="ts">
const props = defineProps({
  modalId: {
    type: String,
    default: 'modalId'
  },
  modalTitle: {
    type: String,
    default: 'Title'
  },
  isOpened: {
    type: Boolean,
    default: false
  }
})
</script>

<template>
  <div v-if="isOpened" :id="modalId" class="modal modal-mask fade anim-fall show animate" role="dialog" aria-labelledby="{{ modalId }}Label">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ modalTitle }}</h5>
        </div>
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-mask {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
}
</style>