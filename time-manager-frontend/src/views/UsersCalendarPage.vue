<script setup lang="ts">
import { onMounted, toRefs, ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import WorkingtimeForm from '@/components/features/workingtimes/WorkingtimeForm.vue';
import WorkingtimeInfo from '@/components/features/workingtimes/WorkingtimeInfo.vue';
import { useUsersStore } from '@/stores/users';
import { useWorkingtimesStore } from '@/stores/workingtimes';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import interactionPlugin from '@fullcalendar/interaction';

import type { DateSelectArg, EventClickArg } from '@fullcalendar/core';

const route = useRoute();
const userID = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;

const userStore = useUsersStore();
const workingtimeStore = useWorkingtimesStore();
const { currentUser } = toRefs(userStore);
const { workingtimes } = toRefs(workingtimeStore);

const isFormOpened = ref(false);
const isDetailModalOpened = ref(false);

type Workingtime = {
  id?: string;
  start: string | Date;
  end: string | Date;
  user_id?: string | { [key: number]: string };
};

const selectedWorkingtime = ref<Workingtime | null>(null);

const calendarOptions = ref({
  plugins: [dayGridPlugin, timeGridPlugin, interactionPlugin, listPlugin],
  initialView: 'dayGridMonth',
  headerToolbar: {
    left: 'prev,next today',
    center: 'title',
    right: 'dayGridMonth,timeGridWeek,timeGridDay,listMonth'
  },
  editable: true,
  selectable: true,
  events: computed(() => workingtimes.value.map(wt => ({
    id: wt.id,
    title: 'WorkingTime',
    start: wt.start,
    end: wt.end
  }))),
  select: handleDateSelect,
  eventClick: handleEventClick
});

function handleDateSelect(selectInfo: DateSelectArg) {
  selectedWorkingtime.value = {
    start: selectInfo.startStr,
    end: selectInfo.endStr
  };
  isFormOpened.value = true;
}

function handleEventClick(clickInfo: EventClickArg) {
  const workingtime = workingtimes.value.find(wt => wt.id === clickInfo.event.id);
  if (workingtime) {
    selectedWorkingtime.value = workingtime;
    isDetailModalOpened.value = true;
  }
}

function closeModal() {
  isFormOpened.value = false;
  isDetailModalOpened.value = false;
  selectedWorkingtime.value = null;
}

async function handleWorkingtimeSubmit(workingtime: { workingtime: Workingtime }) {
  const id_workingtime = workingtime.workingtime.id ;
  if (id_workingtime) {
    await workingtimeStore.updateWorkingtime(id_workingtime, workingtime);
  } else {
    await workingtimeStore.createWorkingtime(userID, workingtime);
  }
  closeModal();
}

async function editWorkingtime(workingtimeId: string) {
  isDetailModalOpened.value = false;   // on ferme le modal de détails
  const workingtime = workingtimes.value.find(wt => wt.id === workingtimeId); // On Trouve le workingtime correspondant
  
  if (workingtime) {
    selectedWorkingtime.value = { ...workingtime }; // Mettre à jour selectedWorkingtime avec les données actuelles
    isFormOpened.value = true;
  }
}

async function deleteWorkingtime(workingtimeId: string) {
  if (confirm('Are you sure you want to delete this working time?')) {
    const success = await workingtimeStore.deleteWorkingtime(workingtimeId);
    if (success) {
      closeModal();
    } else {
      console.error('Failed to delete working time');
    }
  }
}

onMounted(async () => {
  await userStore.getUser(userID);
  await workingtimeStore.getWorkingtimes(userID);
});
</script>

<template>
  <main>
    <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item" aria-current="page">General Agenda</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Workingtime management</h2>
        </div>
      </div>
    </div>

    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-body">
            <div class="calendar-container">
              <FullCalendar :options="calendarOptions" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <WorkingtimeForm
      :workingtime="selectedWorkingtime"
      :isOpened="isFormOpened"
      @close="closeModal"
      @submit="handleWorkingtimeSubmit"
    />
    <WorkingtimeInfo
      :workingtime="selectedWorkingtime"
      :isOpened="isDetailModalOpened"
      @close="closeModal"
      @edit="editWorkingtime"
      @delete="deleteWorkingtime"
    />
  </main>
</template>

<style scoped>
.calendar-container {
    margin-top: 20px;
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

:deep(.fc-col-header-cell-cushion) {
    background-color: #696d72;
    color: white;
    padding: 10px;
}

:deep(.fc-event) {
    border-radius: 8px;
    cursor: pointer;
}

:deep(.fc-day-today) {
    background-color: #cce5ff !important; /* Remplacer par une couleur bleue */
    color: #004085 !important; /* Ajuster la couleur du texte si nécessaire */
}

:deep(.fc-daygrid-day-number) {
    color: #333;
    font-weight: bold;
}


</style>