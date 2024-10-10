import { API } from "@/services";
import type { User, UserRequest } from "@/services/users/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useUsersStore = defineStore('users', () => {
  const users = ref<User[]>([]);
  const currentUser = ref<User | null>(null);
  const selectedUser = ref<User | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  const getUsers = async (email: string | null = null, username: string | null = null) => {
    isLoading.value = true;
    error.value = null;

    try {
      users.value = (await API.users.getUsers(email, username)).data.data;
    } catch (errors) {
      error.value = 'Error when retrieving users.';
    } finally {
      isLoading.value = false;
    }
  };

  const getUser = async () => {
    isLoading.value = true;
    error.value = null;

    API.users.getUser(import.meta.env.VITE_DEFAULT_USER).then((response) => {
      currentUser.value = response.data.data;
    })
    .catch((errors) => {
      error.value = 'Error while retrieving user.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const createUser = async (data: UserRequest) => {
    isLoading.value = true;
    error.value = null;

    API.users.createUser(data).then((response) => {
      users.value.push(response.data.data);
    })
    .catch((errors) => {
      error.value = 'Error when creating user.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const updateUser = async (userId: string, data: Partial<UserRequest>) => {
    isLoading.value = true;
    error.value = null;

    API.users.updateUser(userId, data).then((response) => {
      const updatedUser = response.data.data;
      const index = users.value.findIndex(user => user.id === userId);
        if (index !== -1) {
          users.value[index] = updatedUser;
        }
    })
    .catch((errors) => {
      error.value = 'Error when updating user.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const deleteUser = async (userId: string) => {
    isLoading.value = false;
    try {
      await API.users.deleteUser(userId);
      users.value = users.value.filter(user => user.id !== userId);
    } catch (errors) {
      error.value = 'Error when deleting user.';
      isLoading.value = false;
    }
  }

  return { users, currentUser, isLoading, selectedUser, error, getUsers, getUser, createUser, updateUser, deleteUser };
})