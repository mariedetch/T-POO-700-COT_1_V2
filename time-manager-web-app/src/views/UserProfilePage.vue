<script setup lang="ts">
import { useUsersStore } from '@/stores/users';
import { toRefs } from 'vue';

const userStore = useUsersStore()
const { currentUser } = toRefs(userStore)
</script>

<template>
  <main>
    <div class="pc-content">
      <div class="page-header">
        <div class="page-block">
          <ul class="breadcrumb">
            <li class="breadcrumb-item"><a href="#">Dashboard</a></li>
            <li class="breadcrumb-item"><a href="javascript: void(0)">Account Profile</a></li>
          </ul>
          <div class="page-header-title">
            <h2 class="mb-0">My Profile</h2>
          </div>
        </div>
      </div>
    </div>
    <div class="grid grid-cols-12 gap-6">
      <div class="col-span-12">
        <div class="grid grid-cols-12 gap-6">
          <div class="col-span-12 lg:col-span-4 2xl:col-span-3">
            <div class="card">
              <div class="card-body relative">
                <div class="text-center mt-3">
                  <div class="chat-avtar inline-flex mx-auto justify-center">
                    <img
                      class="rounded-full w-[60px]"
                      src="@/assets/img/user/avatar-1.jpg"
                      alt="User image"
                    />
                  </div>
                  <h5 class="mb-0">{{ currentUser?.username }}</h5>
                  <p class="text-muted text-sm">General Manager</p>
                  <hr class="my-4 border-secondary-500/10" />
                  <div
                    class="grid grid-cols-12 gap-0 divide-x rtl:divide-x-reverse divide-inherit divide-theme-border dark:divide-themedark-border"
                  >
                  </div>
                  <hr class="my-4 border-secondary-500/10" />
                  <div class="inline-flex items-center gap-3 w-full mb-3">
                    <i class="ti ti-mail"></i>
                    <p class="mb-0">{{ currentUser?.email }}</p>
                  </div>
                  <div class="inline-flex items-center gap-3 w-full mb-3">
                    <i class="ti ti-phone"></i>
                    <p class="mb-0">---</p>
                  </div>
                  <div class="inline-flex items-center gap-3 w-full mb-3">
                    <i class="ti ti-map-pin"></i>
                    <p class="mb-0">---</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-span-12 lg:col-span-8 2xl:col-span-9">
            <div class="card">
              <div class="card-header">
                <h5>Personal Details</h5>
              </div>
              <div class="card-body">
                <ul
                  class="*:py-4 divide-y divide-inherit border-theme-border dark:border-themedark-border"
                >
                  <li class="list-group-item px-0 pt-0">
                    <div class="grid grid-cols-12 gap-6">
                      <div class="col-span-12 md:col-span-6">
                        <p class="mb-1 text-muted">UserName</p>
                        <p class="mb-0">{{ currentUser?.username }}</p>
                      </div>
                      <div class="col-span-12 md:col-span-6">
                        <p class="mb-1 text-muted">Email</p>
                        <p class="mb-0">{{ currentUser?.email }}</p>
                      </div>
                    </div>
                  </li>
                  <li class="list-group-item px-0 pb-0">
                    <p class="mb-1 text-muted">Address</p>
                    <p class="mb-0">---</p>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>