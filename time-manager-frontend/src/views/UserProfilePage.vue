<script setup lang="ts">
import { useUsersStore } from '@/stores/users';
import { computed, onMounted, ref, toRefs } from 'vue';
import Modal from '../components/shared/Modal.vue';
import { CredentialService } from '@/utils/credentials';
import { useRouter } from 'vue-router';
import type { UserRequest } from "@/services/users/types";
import { ToastrService } from '@/utils/toastr'

const userStore = useUsersStore();
const { loggedUser } = toRefs(userStore);
const isModalOpen = ref(false);

const userForm = computed(() => ({
  firstName: loggedUser.value?.firstname || '',
  lastName: loggedUser.value?.lastname || '',
  eMail: loggedUser.value?.email || ''
}))

const router = useRouter();

const deleteAccount = async () => {
  await userStore.deleteProfil(); 
  isModalOpen.value = false; 
  CredentialService.clearCredentials();
  router.push({ name: 'dashboard' });
};  

const updateProfile = async () => {
  // const updatedData: Partial<UserRequest> = {
  //   user: {
  //     firstname: userForm.value.firstName,
  //     lastname: userForm.value.lastName,
  //     email: userForm.value.eMail,
  //   }        
  // };
  
  await userStore.updateProfil({user: userForm}); 
  await userStore.getProfil(); 
  ToastrService.success('Your credentials has been successfully updated')
};

onMounted(async () => {
  await userStore.getProfil();
  await userStore.deleteProfil();
});

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
        <div class="card">
          <div class="card-body !py-0">
            <ul class="flex flex-wrap w-full font-medium text-center nav-tabs">
              <li class="group active">
                <a href="javascript:void(0);" data-pc-toggle="tab" data-pc-target="profile-1" class="inline-flex items-center mr-6 py-4 transition-all duration-300 ease-linear border-t-2 border-b-2 border-transparent group-[.active]:text-primary-500 group-[.active]:border-b-primary-500 hover:text-primary-500 active:text-primary-500">
                  <i class="ti ti-user ltr:mr-2 rtl:ml-2 text-lg leading-none"></i> 
                  Profile
                </a>
              </li>
              <li class="group">
                <a href="javascript:void(0);" data-pc-toggle="tab" data-pc-target="profile-2" class="inline-flex items-center mr-6 py-4 transition-all duration-300 ease-linear border-t-2 border-b-2 border-transparent group-[.active]:text-primary-500 group-[.active]:border-b-primary-500 hover:text-primary-500 active:text-primary-500">
                  <i class="ti ti-lock ltr:mr-2 rtl:ml-2 text-lg leading-none"></i> 
                  Change Password
                </a>
              </li>
              <li class="group">
                <a href="javascript:void(0);" data-pc-toggle="tab" data-pc-target="profile-3" class="inline-flex items-center mr-6 py-4 transition-all duration-300 ease-linear border-t-2 border-b-2 border-transparent group-[.active]:text-primary-500 group-[.active]:border-b-primary-500 hover:text-primary-500 active:text-primary-500">
                  <i class="ti ti-settings ltr:mr-2 rtl:ml-2 text-lg leading-none"></i> 
                  Settings
                </a>
              </li>
            </ul>
          </div>
        </div>
        <div class="tab-content">
          <div class="tab-pane block" id="profile-1">
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
                    <h5 class="mb-0">{{ loggedUser?.firstname + ' ' + loggedUser?.lastname }}</h5>
                    <p class="text-muted text-sm">{{ loggedUser?.role }}</p>
                    <hr class="my-4 border-secondary-500/10" />
                    <div
                      class="grid grid-cols-12 gap-0 divide-x rtl:divide-x-reverse divide-inherit divide-theme-border dark:divide-themedark-border"
                    >
                    </div>
                    <hr class="my-4 border-secondary-500/10" />
                    <div class="inline-flex items-center gap-3 w-full mb-3">
                      <i class="ti ti-mail"></i>
                      <p class="mb-0">{{ loggedUser?.email }}</p>
                    </div>
                    <div class="inline-flex items-center gap-3 w-full mb-3">
                      <i class="ti ti-phone"></i>
                      <p class="mb-0"></p>
                    </div>
                  </div>
                </div>
                </div>
              </div>
              <div class="col-span-12 lg:col-span-8 2xl:col-span-9">
                <div class="card">
                  <div class="card-header">
                    <h5>Edit Profil</h5>
                  </div>
                  <form @submit.prevent="updateProfile">
                    <div class="card-body">
                      <div class="grid grid-cols-12 gap-6">
                        <div class="col-span-12 sm:col-span-6">
                          <div class="mb-3">
                            <label class="form-label">First Name</label> 
                            <input type="text" id="firstName" class="form-control" :v-model="userForm.firstName">
                          </div>
                        </div>
                        <div class="col-span-12 sm:col-span-6">
                          <div class="mb-3">
                            <label class="form-label">Last Name</label> 
                            <input type="text" id="lastName" class="form-control" :v-model="userForm.lastName">
                          </div>
                        </div>
                        <div class="col-span-12 sm:col-span-6">
                          <div class="mb-3"><label class="form-label">Email</label> 
                            <input type="text" id="email" class="form-control" v-model="userForm.eMail">
                          </div>
                        </div>
                        <div class="col-span-12 sm:col-span-6">
                          <div class="mb-3"><label class="form-label">Tel</label> 
                            <input type="text" class="form-control" value="956754">
                          </div>
                        </div>
                        <div class="card-footer text-left btn-page">
                          <button type="submit" class="btn btn-primary mx-1">Update</button>
                        </div>
                      </div>
                    </div>
                  </form>
                  
                </div>
              </div>
            </div>
          </div>
          <div class="tab-pane block" id="profile-2">
            <div class="card">
              <div class="card-header">
                <h5>Change Password</h5>
              </div><div class="card-body">
                <div class="grid grid-cols-12 gap-6">
                  <div class="col-span-12 sm:col-span-6">
                    <div class="mb-3">
                      <label class="form-label">Old Password</label> 
                      <input type="password" class="form-control">
                    </div>
                    <div class="mb-3">
                      <label class="form-label">New Password</label> 
                      <input type="password" class="form-control">
                    </div>
                    <div class="mb-3">
                      <label class="form-label">Confirm Password</label> 
                      <input type="password" class="form-control">
                    </div>
                  </div>
                  <div class="col-span-12 sm:col-span-6">
                    <h5>New password must contain:</h5>
                    <ul class="rounded-lg *:py-4 *:px-0 divide-y divide-inherit border-theme-border dark:border-themedark-border">
                      <li class="list-group-item">
                        <i class="ti ti-circle-check text-success f-16 me-2"></i> 
                        At least 8 characters
                      </li>
                      <li class="list-group-item">
                        <i class="ti ti-circle-check text-success f-16 me-2"></i> 
                        At least 1 lower letter (a-z)
                      </li>
                      <li class="list-group-item">
                        <i class="ti ti-circle-check text-success f-16 me-2"></i> 
                        At least 1 uppercase letter(A-Z)
                      </li>
                      <li class="list-group-item">
                        <i class="ti ti-circle-check text-success f-16 me-2"></i> 
                        At least 1 number (0-9)
                      </li>
                      <li class="list-group-item">
                        <i class="ti ti-circle-check text-success f-16 me-2"></i>
                         At least 1 special characters
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
              <div class="card-footer text-right btn-page">
                <div type="submit" class="btn btn-primary mx-1">Update Profile</div>
              </div>
            </div>
          </div>
          <div class="tab-pane pane" id="profile-3">
            <div class="grid grid-cols-12 gap-6">
              <div class="col-span-12 md:col-span-6">
                <div class="card">
                  <div class="card-header">
                    <h5>Delete accout</h5>
                  </div>
                  <div class="card-body">
                    <h6 class="mb-4">Are you sure you want to delete ?</h6>
                    <div class="flex items-center justify-between mb-1">
                      <div>
                        <p class="mb-0 text-danger">Delete account</p>
                      </div>
                      <button class="btn btn-danger" @click="isModalOpen = true">
                        <i class="ti ti-trash text-white leading-none"></i> 
                      </button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <Modal :modalId="'deleteAccountModal'" modalTitle="Confirm Deletion" :isOpened="isModalOpen">
            <div class="modal-body">
              <p>Are you sure you want to delete your account? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
              <button class="btn btn-secondary" @click="isModalOpen = false">Cancel</button>
              <button class="btn btn-danger" @click="deleteAccount">Delete</button>
            </div>
          </Modal>
        </div>
      </div>
    </div>
    
  </main>
</template>