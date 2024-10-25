<script setup lang="ts">
import { useTeamsStore } from '@/stores/teams'
import { onMounted, computed, toRefs } from 'vue'
import PaginationHeader from '@/components/paginations/Header.vue';
import PaginationFooter from '@/components/paginations/Footer.vue';
import Swal from 'sweetalert2';
import { ToastrService } from '@/utils/toastr';

const teamStore = useTeamsStore()
const { teams, currentPage, pageSize, totalCount } = toRefs(teamStore)
const props = defineProps({ userRole: { type: String, default: '' } });

const startCount = computed(() => (
  (currentPage.value - 1) * pageSize.value
));
const totalPages = computed(() => (
  Math.ceil(totalCount.value / pageSize.value)
));

const refetchData = (page: number, size: number) => {
  teamStore.getTeams(page, size)
}

const confirmDelete = async (teamId: string) => {
  const result = await Swal.fire({
    title: 'Êtes-vous sûr ?',
    text: 'Cette action ne peut pas être annulée !',
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'Oui, supprimer',
    cancelButtonText: 'Annuler'
  })

  if (result.isConfirmed) {
    if (await teamStore.deleteTeam(teamId)) {
      ToastrService.success('Team deleted successfully')
    } else {
      ToastrService.success('You cannot deleted this team at this moment!!!')
    }
  }
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString);

  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const formattedDate = `${year}/${month}/${day}`;

  let hours = date.getHours();
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const ampm = hours >= 12 ? 'PM' : 'AM';
  hours = hours % 12;
  hours = hours ? hours : 12;
  const formattedTime = `${hours}:${minutes} ${ampm}`;

  return {
    date: formattedDate,
    time: formattedTime,
  };
};

onMounted(async () => {
  await teamStore.getTeams()
})
</script>

<template>
  <div class="table-responsive">
    <PaginationHeader
      :currentPage="currentPage"
      :pageSize="pageSize"
    />
    <table class="table table-hover" id="pc-dt-simple">
      <thead>
        <tr>
          <th>#</th>
          <th v-if="userRole === 'GENERAL_MANAGER'">Manager</th>
          <th>Name</th>
          <th>Description</th>
          <th>Created at</th>
          <!-- <th>Nb Members</th> -->
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(team, index) in teams" :key="team.id">
          <td class="text-right">{{ startCount + index + 1 }}</td>
          <td v-if="userRole === 'GENERAL_MANAGER'">
            <div class="flex items-center w-44">
              <div class="shrink-0">
                <img
                  src="@/assets/img/user/avatar-4.jpg"
                  alt="user image"
                  class="rounded-full w-10"
                />
              </div>
              <div class="grow ltr:ml-3 rtl:mr-3">
                <h6 class="mb-0">{{ team.manager?.firstname + ' ' + team.manager?.lastname }}</h6>
                <p class="text-muted text-sm mb-0">{{ team.manager?.email }}</p>
              </div>
            </div>
          </td>
          <td>{{ team.name }}</td>
          <td>{{ team.description }}</td>
          <td>
            {{ formatDate(team.inserted_at).date }}
            <span class="text-muted text-sm block">{{ formatDate(team.inserted_at).time }}</span>
          </td>
          <!-- <td>
            <span
              class="badge bg-warning-500/10 border border-warning text-warning-500 rounded-full text-sm"
              >{{ team.member_count }} members</span
            >
          </td> -->
          <td>
            <RouterLink
              :to="`/teams/${team.id}`"
              class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary"
              ><i class="ti ti-eye text-xl leading-none"></i> </RouterLink
            ><a
              href="#"
              @click="confirmDelete(team.id)"
              class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary"
              ><i class="ti ti-trash text-xl leading-none"></i
            ></a>
          </td>
        </tr>
      </tbody>
    </table>
    <PaginationFooter
      :currentPage="currentPage"
      :pageSize="pageSize"
      :totalCount="totalCount"
      :startCount="startCount"
      :totalPages="totalPages"
      @fetchData="refetchData"
    />
  </div>
</template>
