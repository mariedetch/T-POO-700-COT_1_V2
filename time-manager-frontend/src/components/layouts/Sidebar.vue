<script setup lang="ts">
import { User } from '@/components/features/users'
import { UserRole } from '@/services/auth/types'
import { useAuthStore } from '@/stores/auth';
import { toRefs } from 'vue';

const authStore = useAuthStore();
const { authUser } = toRefs(authStore);

const hasRole = (role: string | string[]) => {
  if (Array.isArray(role)) {
    return authUser.value && role.includes(authUser.value.role);
  }
  else return authUser.value && authUser.value.role === role;
};
</script>

<template>
  <nav class="pc-sidebar">
    <div class="navbar-wrapper">
      <div class="m-header flex items-center py-4 px-6 h-header-height">
        <a href="#" class="b-brand flex items-center gap-3">
          <img src="@/assets/logo.svg" class="img-fluid logo-lg" alt="logo" />
          <span class="badge bg-success-500/10 text-success-500 rounded-full theme-version"
            >v1.0.0</span
          >
        </a>
      </div>
      <div class="navbar-content h-[calc(100vh_-_74px)] py-2.5">
        <User />
        <ul class="pc-navbar">
          <li class="pc-item">
            <RouterLink to="/" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-dashboard"></i>
              <span class="pc-mtext">Dashboard</span>
            </RouterLink>
          </li>
          <li class="pc-item">
            <RouterLink :to="{ name: 'calendar'}" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-calendar-month"></i>
              <span class="pc-mtext">My Calendar</span>
            </RouterLink>
          </li>
          <!-- <li class="pc-item" v-if="hasRole([UserRole.GENERAL_MANAGER, UserRole.MANAGER])">
            <RouterLink :to="{ name: 'agenda' }" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-calendar-week"></i>
              <span class="pc-mtext">General Agenda</span>
            </RouterLink>
          </li> -->
          <li class="pc-item" v-if="hasRole(UserRole.GENERAL_MANAGER)">
            <RouterLink :to="{ name: 'staff' }" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-users"></i>
              <span class="pc-mtext">Staff</span>
            </RouterLink>
          </li>
          <li class="pc-item" v-if="hasRole([UserRole.GENERAL_MANAGER, UserRole.MANAGER])">
            <RouterLink :to="{ name: 'teams' }" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-sitemap"></i>
              <span class="pc-mtext">Teams</span>
            </RouterLink>
          </li>
          <li class="pc-item" v-if="hasRole(UserRole.MANAGER)">
            <RouterLink :to="{ name: 'employees' }" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-users"></i>
              <span class="pc-mtext">Employees</span>
            </RouterLink>
          </li>
          <li class="pc-item">
            <RouterLink :to="{ name: 'punctualities' }" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-alarm"></i>
              <span class="pc-mtext">My Punctualities</span>
            </RouterLink>
          </li>
          <!-- <li class="pc-item">
            <RouterLink to="/team" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-users"></i>
              <span class="pc-mtext">My team</span>
            </RouterLink>
            <RouterLink to="/users" v-if="hasRole(UserRole.GENERAL_MANAGER)" class="pc-link text-black">
          </li> -->
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.router-link-exact-active {
  color: rgb(var(--colors-primary-500));
  background-color: rgb(70 128 255 / 14%);
  border-radius: 10px;
}
</style>