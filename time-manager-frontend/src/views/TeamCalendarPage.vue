<script setup lang="ts">
import { onMounted, toRefs, ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import { ToastrService } from '@/utils/toastr'
import WorkingtimeFormTeam from '@/components/features/workingtimes/WorkingtimeFormTeam.vue';
import WorkingtimeInfoTeam from '@/components/features/workingtimes/WorkingtimeInfoTeam.vue';
import { useUsersStore } from '@/stores/users';
import { useWorkingtimesStore } from '@/stores/workingtimes';
import FullCalendar from '@fullcalendar/vue3';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';
import interactionPlugin from '@fullcalendar/interaction';

import type { DateSelectArg, EventClickArg } from '@fullcalendar/core';

const route = useRoute();
const teamID = Array.isArray(route.params.id) ? route.params.id[0] : route.params.id;

console.log("Team ID ", teamID)

const userID = Array.isArray(route.params.userID) ? route.params.userID[0] : route.params.userID;

const userStore = useUsersStore();
const workingtimeStore = useWorkingtimesStore();
const { currentUser } = toRefs(userStore);
const { workingtimes } = toRefs(workingtimeStore);

const isFormOpened = ref(false);
const isDetailModalOpened = ref(false);
const calendarRef = ref<InstanceType<typeof FullCalendar> | null>(null);

type Workingtime = {
  id?: string;
  start: string | Date;
  end: string | Date;
  user_id?: string | { [key: number]: string };
};

const selectedWorkingtime = ref<Workingtime | null>(null);

const eventClasses = ['event-1', 'event-2', 'event-3', 'event-4', 'event-5', 
                      'event-6', 'event-7', 'event-8', 'event-9', 'event-10'];
const userClassMap = new Map<string, string>();
let classIndex = 0;

function getEventClass(userId: string): string {
  if (!userId) return eventClasses[0]; // Classe par défaut si pas d'userId

  if (!userClassMap.has(userId)) {
    userClassMap.set(userId, eventClasses[classIndex % eventClasses.length]);
    classIndex++;
  }

  return userClassMap.get(userId) || eventClasses[0];
}

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
  dayMaxEvents: 2, // 2 évènements maximum par jour
  events: computed(() => workingtimes.value.map(wt => ({
    id: wt.id,
    title: 'WorkingTime',
    start: wt.start,
    end: wt.end,
    className: getEventClass(wt.user?.id || 'default')
  }))),
  select: handleDateSelect,
  eventClick: handleEventClick
});

// Fonction pour rafraîchir le calendrier
async function refreshCalendar() {
  await workingtimeStore.getTeamWorkingtimes(userID);
  if (calendarRef.value) {
    const calendarApi = calendarRef.value.getApi();
    calendarApi.refetchEvents();
  }
}

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

async function handleWorkingtimeSubmit(workingtime: any) {
  const id_workingtime = workingtime.workingtime.id ;
  if (id_workingtime) {
    await workingtimeStore.updateWorkingtime(id_workingtime, workingtime);
  } else {
    await workingtimeStore.createTeamWorkingtime(teamID, workingtime);
    await refreshCalendar(); // Rafraîchir le calendrier après la soumission
    ToastrService.success('WorkingTime created successfully')
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
  await workingtimeStore.getTeamWorkingtimes(teamID);
});
</script>

<template>
  <main>
    <!-- <div class="page-header">
      <div class="page-block">
        <ul class="breadcrumb">
          <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
          <li class="breadcrumb-item" aria-current="page">General Agenda</li>
        </ul>
        <div class="page-header-title flex flex-row justify-between items-center">
          <h2 class="mb-0">Workingtime management</h2>
        </div>
      </div>
    </div> -->

    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="card table-card">
          <div class="card-body">
            <div class="calendar-container">
              <FullCalendar ref="calendarRef" :options="calendarOptions" />
            </div>
          </div>
        </div>
      </div>
    </div>

    <WorkingtimeFormTeam
      :workingtime="(selectedWorkingtime as any)"
      :isOpened="isFormOpened"
      @close="closeModal"
      @submit="handleWorkingtimeSubmit"
    />
    <WorkingtimeInfoTeam
      :workingtime="(selectedWorkingtime as any)"
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
    border-radius: 10px;
    cursor: pointer;
}

:deep(.event-5) {
    background-color: #FF6B6B !important;
    border-color: #FF6B6B !important;
    color: white !important;
}

:deep(.event-3) {
    background-color: #4ECDC4 !important;
    border-color: #4ECDC4 !important;
    color: white !important;
}

:deep(.event-2) {
    background-color: #45B7D1 !important;
    border-color: #45B7D1 !important;
    color: white !important;
}

:deep(.event-4) {
    background-color: #96CEB4 !important;
    border-color: #96CEB4 !important;
    color: white !important;
}

:deep(.event-1) {
    background-color: #9B5DE5 !important;
    border-color: #9B5DE5 !important;
    color: white !important;
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