<script setup lang="ts">
import { ref, toRefs, computed, onMounted } from 'vue'
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import Modal from '../components/shared/Modal.vue'
import { useWorkingtimesStore } from '@/stores/workingtimes';

import type { EventClickArg } from '@fullcalendar/core';

const workingtimeStore = useWorkingtimesStore();
const { workingtimes } = toRefs(workingtimeStore);

interface CalendarEvent {
  id: string
  title: string
  start: Date | string | null
  end: Date | string | null
}

const selectedEvent = ref<CalendarEvent>({
  id: '',
  title: '',
  start: null,
  end: null
})

const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
  initialView: 'dayGridMonth',
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
  },
  events: computed(() => workingtimes.value.map(wt => ({
    id: wt.id,
    title: 'WorkingTime',
    start: wt.start,
    end: wt.end
  }))),
  dayMaxEvents: true,
  weekends: true,
  selectable: true, // Permet la sélection de dates
  eventClick: handleEventClick
})

const isModalOpen = ref(false)
// const selectedEvent = ref({ title: '', start: '', end: '' })

function handleEventClick(clickInfo: EventClickArg) {
  selectedEvent.value = {
    id: clickInfo.event.id,
    title: clickInfo.event.title,
    start: clickInfo.event.start,
    end: clickInfo.event.end,
  }
  isModalOpen.value = true
}

function closeModal() {
  isModalOpen.value = false
}

// const formattedStartTime = computed(() => {
//   if (selectedEvent.value) {
//     return new Date(selectedEvent.value.start).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
//   }
//   return '';
// });

// const formattedEndTime = computed(() => {
//   if (selectedEvent) {
//     return new Date(selectedEvent.value.end).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
//   }
//   return '';
// });

const formatDate = (dateValue: Date | string | null): string => {
  if (!dateValue) return '';
  return new Date(dateValue).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

// Computed formatedStartTime and formatedEndTime 
const formattedStartTime = computed(() => formatDate(selectedEvent.value.start))
const formattedEndTime = computed(() => formatDate(selectedEvent.value.end))

onMounted(async () => {
  await workingtimeStore.getCurrentUserWorkingtimes();
});
</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item" aria-current="page">My Calendar</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">My Calendar</h2>
        </div>
      </div>
    </div>
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-body">
            <div class="calendar-wrapper">
              <FullCalendar :options="calendarOptions" />

              <Modal
                :modalId="'eventModal'"
                :modalTitle="selectedEvent.title"
                :isOpened="isModalOpen"
              >
                <div class="modal-body">
                  <div class="event-detail">
                    <i class="ti ti-calendar"></i>
                    <span>
                      {{
                        selectedEvent.start
                          ? new Date(selectedEvent.start).toLocaleDateString()
                          : ''
                      }}</span
                    >
                  </div>
                  <div class="event-detail me_bold">
                    <i class="ti ti-clock"></i>
                    <span> {{selectedEvent.end ? formattedStartTime : '' }} - {{selectedEvent.end ? formattedEndTime : ''}} </span>
                  </div>
                  <div class="event-detail">
                    <i class="ti ti-notes"></i>
                    <span>No comment</span>
                  </div>
                </div>
                <div class="modal-footer">
                  <button @click="closeModal" class="btn btn-primary">Fermer</button>
                </div>
              </Modal>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

