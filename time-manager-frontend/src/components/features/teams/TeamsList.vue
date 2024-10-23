<script setup lang="ts">
import { useTeamsStore } from '@/stores/teams'
import { onMounted, computed, toRefs } from 'vue'
import PaginationHeader from '@/components/paginations/Header.vue';
import PaginationFooter from '@/components/paginations/Footer.vue';

const teamStore = useTeamsStore()
const { teams, error, isLoading, currentPage, pageSize, totalCount } = toRefs(teamStore)

const startCount = computed(() => (
  (currentPage.value - 1) * pageSize.value
));
const totalPages = computed(() => (
  Math.ceil(totalCount.value / pageSize.value)
));

const refetchData = (page: number, size: number) => {
  teamStore.getTeams(page, size)
}

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
          <th>Manager</th>
          <th>Name</th>
          <th>Description</th>
          <th>Created at</th>
          <th>Nb Members</th>
          <th class="text-center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(team, index) in teams" :key="team.id">
          <td class="text-right">{{ startCount + index + 1 }}</td>
          <td>
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
          <td>2023/02/07 <span class="text-muted text-sm block">09:05 PM</span></td>
          <td>
            <span
              class="badge bg-danger-500/10 border border-danger text-danger-500 rounded-full text-sm"
              >{{ team.member_count }} members</span
            >
          </td>
          <td>
            <a
              href="#"
              class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary"
              ><i class="ti ti-eye text-xl leading-none"></i> </a
            ><a
              href="#"
              class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary"
              ><i class="ti ti-edit text-xl leading-none"></i> </a
            ><a
              href="#"
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
