<script setup>
import { ref, computed } from 'vue'
import FullCalendar from '@fullcalendar/vue3'
import dayGridPlugin from '@fullcalendar/daygrid'
import timeGridPlugin from '@fullcalendar/timegrid'
import listPlugin from '@fullcalendar/list'
import frLocale from '@fullcalendar/core/locales/fr'
import Modal from '../components/shared/Modal.vue'

const calendarOptions = ref({
    plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
    initialView: 'dayGridMonth',
    locales: [frLocale],
    locale: 'fr',
    headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
    },
    events: [
        { title: 'Événement 1', date: '2024-10-20', start: '2024-10-20T10:00:00', end: '2024-10-20T17:00:00' },
        { title: 'Événement 2', date: '2024-10-22', start: '2024-10-22T14:00:00', end: '2024-10-22T15:00:00' }
    ],
    dayMaxEvents: true,
    weekends: true,
    selectable: true, // Permet la sélection de dates
    eventClick: handleEventClick
})

const isModalOpen = ref(false)
const selectedEvent = ref({ title: '', start: '', end: '' })

function handleEventClick(clickInfo) {
    selectedEvent.value = clickInfo.event
    isModalOpen.value = true
}

function closeModal() {
    isModalOpen.value = false
}

</script>

<template>
    <div class="calendar-wrapper">
        <h1 class="calendar-title">Mon Calendrier</h1>
        <FullCalendar :options="calendarOptions" class="calendar-container"/>

        <Modal 
            :modalId="'eventModal'" 
            :modalTitle="selectedEvent.title" 
            :isOpened="isModalOpen"
        >
            <div class="modal-body">
                <div class="event-detail">
                    <i class="ti ti-calendar"></i>
                    <span> {{ selectedEvent.start ? new Date(selectedEvent.start).toLocaleDateString() : '' }}</span>
                </div>
                <div class="event-detail me_bold">
                    <i class="ti ti-clock"></i>
                    <span> {{ selectedEvent.start ? new Date(selectedEvent.start).toLocaleTimeString() : '' }} - {{ selectedEvent.end ? new Date(selectedEvent.end).toLocaleTimeString() : '' }}</span>
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
</template>

<style scoped>
.calendar-wrapper {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

.calendar-title {
    color: #333;
    margin-bottom: 20px;
}

.calendar-container {
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

:deep(.fc-col-header-cell-cushion) {
    background-color: #4a4a4a;
    color: white;
    padding: 10px;
}

:deep(.fc-daygrid-day-number) {
    color: #333;
    font-weight: bold;
}

:deep(.fc-list-event:hover) {
    text-decoration: underline;
    color: #3788d8;
     /* Souligner le texte au survol */
}

:deep(.fc-event) {
    background-color: #3788d8;
    border: none;
    border-radius: 4px;
    color: white;
    cursor: pointer;
}

.modal-body {
    padding: 20px;
}

.event-detail {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.event-detail i {
    margin-right: 10px;
    color: #3788d8;
}

.event-detail span {
    color: #333;
}
.me_bold{
    font-weight: bold;
}

:deep(.fc-day-today) {
    background-color: #cce5ff !important; /* Remplacer par une couleur bleue */
    color: #004085 !important; /* Ajuster la couleur du texte si nécessaire */
}
</style>