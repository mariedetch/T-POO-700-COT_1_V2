import { API } from "@/services";
import type { User, UserRequest } from "@/services/users/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useUsersStore = defineStore('users', () => {
  const users = ref<User[]>([]);
  const selectedUser = ref<User | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  const getUsers = async () => {
    isLoading.value = true;
    error.value = null;

    try {
      users.value = (await API.users.getUsers()).data.data;
      console.log("Utilisateurs récupérés avec succès :");
    } catch (errors) {
      error.value = 'Erreur lors de la récupération des utilisateurs.';
    } finally {
      isLoading.value = false;
    }
  };

  const createUser = async (data: UserRequest) => {
    isLoading.value = true;
    error.value = null;

    /* API.users.createUser(data).then((response) => {
      users.value.push(response.data.data);
      console.log("Utilisateur crée avec succès :");
    })
    .catch((error) => {
      error.value = 'Erreur lors de la création de l\'utilisateur.';
    })
    .finally(() => {
      isLoading.value = false;
    }); */
  };

  return { users, isLoading, selectedUser, error, getUsers, createUser };
})