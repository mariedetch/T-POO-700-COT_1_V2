import { API } from "@/services";
import type { User, UserRequest } from "@/services/users/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useUsersStore = defineStore('users', () => {
  const users = ref<User[]>([]);
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

    /* await API.users.getUsers().then((response) => {
      users.value = response.data.data;
      console.log("Utilisateurs récupérés avec succès :");
    })
    .catch((error) => {
      error.value = 'Erreur lors de la récupération des utilisateurs.';
    })
    .finally(() => {
      isLoading.value = false;
    }); */
  };
  const sleep = (ms: number | undefined) => new Promise(resolve => setTimeout(resolve, ms));

  const createUser = async (data: UserRequest) => {
    isLoading.value = true;
    error.value = null;

    await sleep(10000);

    API.users.createUser(data).then((response) => {
      users.value.push(response.data.data);
      console.log("Utilisateur crée avec succès :");
    })
    .catch((error) => {
      error.value = 'Erreur lors de la création de l\'utilisateur.';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  return { users, isLoading, error, getUsers, createUser };
})