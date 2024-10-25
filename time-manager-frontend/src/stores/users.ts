import { API } from "@/services";
import type { User, UserRequest } from "@/services/users/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useUsersStore = defineStore('users', () => {
  const users = ref<User[]>([]);
  const employees = ref<User[]>([]);
  const userId = import.meta.env.VITE_DEFAULT_USER;
  const currentUser = ref<User | null>(null);
  const loggedUser = ref<User | null>(null);
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

  const getEmployees = async () => {
    isLoading.value = true;
    error.value = null;

    try {
      employees.value = (await API.users.getEmployees()).data.data;
    } catch (errors) {
      error.value = 'Error when retrieving users.';
    } finally {
      isLoading.value = false;
    }
  };

  const getUser = async (userId: string) => {
    isLoading.value = true;
    error.value = null;

    API.users.getUser(userId).then((response) => {
      currentUser.value = response.data.data;
    })
    .catch((errors) => {
      error.value = 'Error while retrieving user.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const getProfil = async () => {
    isLoading.value = true;
    error.value = null;

    API.users.getProfil().then((response) => {
      loggedUser.value = response.data.data;
    })
    .catch((errors) => {
      error.value = 'Error while retrieving account.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  }

  const updateProfil = async (data: Partial<UserRequest>) => {
    isLoading.value = true;
    error.value = null;

    API.users.updateProfil(data).then((response) => {
      loggedUser.value = response.data.data;
    })
    .catch((errors) => {
      error.value = 'Error while updating account.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  }

  const createUser = async (data: UserRequest): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await API.users.createUser(data);
      users.value.push(response.data.data);
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when creating user.';
      isLoading.value = false;
    }

    return false;
  };

  const updateUser = async (userId: string, data: Partial<UserRequest>): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await API.users.updateUser(userId, data);
      const updatedUser = response.data.data;
      const index = users.value.findIndex(user => user.id === userId);
      if (index !== -1) {
        users.value[index] = updatedUser;
      }
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when updating user.';
      isLoading.value = false;
    }

    return false;
  };

  const promoteUser = async (userId: string): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;
    try {
      const response = await API.users.promoteUser(userId);
      const promotedUser = response.data.data;
      const index = users.value.findIndex(user => user.id === userId);
      if (index !== -1) {
        users.value[index] = promotedUser;
      }
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when updating user.';
      isLoading.value = false;
    }

    return false;
  };

  const deleteUser = async (userId: string): Promise<boolean> => {
    isLoading.value = true;
    try {
      await API.users.deleteUser(userId);
      users.value = users.value.filter(user => user.id !== userId);
      isLoading.value = false;
      return true;
    } catch (errors) {
      error.value = 'Error when deleting user.';
      isLoading.value = false;
    }
    return false;
  }

  const deleteProfil = async () => {
    isLoading.value = true;
    error.value = null;

    API.users.getProfil().then((response) => {

    })
    .catch((errors) => {
      error.value = 'Error while deleting account.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  }

  return {
    users, employees, userId, currentUser, isLoading, selectedUser, error,
    loggedUser, getProfil, deleteProfil, updateProfil,
    getUsers, getUser, getEmployees, createUser, updateUser, deleteUser, promoteUser
  };

})