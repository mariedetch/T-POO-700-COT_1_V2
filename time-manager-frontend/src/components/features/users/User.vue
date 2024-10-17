<script setup lang="ts">
import { useUsersStore } from '@/stores/users';
import { onMounted, toRefs } from 'vue';

const userStore = useUsersStore()
const { currentUser, userId } = toRefs(userStore)

onMounted(async () => {
  await userStore.getUser(userId.value);
})
</script>

<template>
  <div
    class="card pc-user-card mx-[15px] mb-[15px] bg-theme-sidebaruserbg dark:bg-themedark-sidebaruserbg"
  >
    <div class="card-body !p-5">
      <div class="flex items-center">
        <img
          class="shrink-0 w-[45px] h-[45px] rounded-full"
          src="@/assets/img/user/avatar-1.jpg"
          alt="user-image"
        />
        <div class="ml-4 mr-2 grow">
          <h6 class="mb-0">{{ currentUser?.username }}</h6>
          <small>{{ currentUser?.email }}</small>
        </div>
        <a
          class="shrink-0 btn btn-icon inline-flex btn-link-secondary"
          data-pc-toggle="collapse"
          href="#pc_sidebar_userlink"
        >
          <i class="text-2xl leading-none ti ti-menu-deep"></i>
        </a>
      </div>
      <div class="hidden pc-user-links" id="pc_sidebar_userlink">
        <div class="pt-3 *:flex *:items-center *:py-2 *:gap-2.5 hover:*:text-primary-500">
          <RouterLink to="/my-profile">
            <i class="text-lg leading-none ti ti-user"></i> <span>My Account</span>
          </RouterLink>
          <a href="#!">
            <i class="text-lg leading-none ti ti-settings"></i>
            <span>Settings</span>
          </a>
          <a href="#!"
            ><i class="text-lg leading-none ti ti-lock"></i> <span>Lock Screen</span> </a
          ><a href="#!"
            ><i class="text-lg leading-none ti ti-power"></i> <span>Logout</span></a
          >
        </div>
      </div>
    </div>
  </div>
</template>