import { API } from "@/services";
import type { Workingtime, WorkingtimeRequest, WorkingtimeRequest_2 } from "@/services/workingtimes/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useWorkingtimesStore = defineStore('workingtimes', () => {
  const workingtimes = ref<Workingtime[]>([]);
  const selectedWorkingtime = ref<Workingtime | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  const getWorkingtimes = async (userID: string | null = null, start: string | null = null, end: string | null = null) => {
    isLoading.value = true;
    error.value = null;

    try {
        workingtimes.value = (await API.workingtimes.getWorkingtimes(userID, start, end)).data.data;
        return workingtimes.value;
    } catch (errors) {
      error.value = 'Error during the working times recovering';
      return [];
    } finally { 
      isLoading.value = false;
    }
  };

  // Workingtime for current user
  const getCurrentUserWorkingtimes = async () => {
    isLoading.value = true;
    error.value = null;
  
    try {
      const response = await API.workingtimes.getCurrentUserWorkingtimes();
      workingtimes.value = response.data.data;

      return workingtimes.value;
    } catch (errors) {
      error.value = 'Error while retrieving your working times';
      return [];
    } finally {
      isLoading.value = false;
    }
  };

  // Récupérer le workingTime d'une équipe
  const getTeamWorkingtimes = async (teamID: string | null = null) => {
    isLoading.value = true;
    error.value = null;

    try {
        workingtimes.value = (await API.workingtimes.getTeamWorkingtimes(teamID)).data.data;
        return workingtimes.value;
    } catch (errors) {
      error.value = 'Error during the working times recovering';
      return [];
    } finally { 
      isLoading.value = false;
    }
  };
  
  const createWorkingtime= async (userID: string, data: WorkingtimeRequest): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await API.workingtimes.createWorkingtime(userID, data);
      workingtimes.value.push(response.data.data);
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error during working time creation';
      isLoading.value = false;
    }

    return false;
  };

  // Créer WorkingTime pour plusieurs users dans une équipe 
  const createTeamWorkingtime= async (teamID: string  | null = null, data: WorkingtimeRequest_2): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await API.workingtimes.createTeamWorkingtime(teamID, data);
      console.log("Backend : ", data);
      workingtimes.value.push(data.workingtime as any);
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error during working time creation';
      isLoading.value = false;
    }
    return false;
  };

  const updateWorkingtime = async (workingtimeId: string, data: Partial<WorkingtimeRequest>): Promise<boolean> => {
    isLoading.value = true;
    error.value = null;

    try {
      const response = await API.workingtimes.updateWorkingtime(workingtimeId, data);
      const updatedWorkingtime = response.data.data;
      const index = workingtimes.value.findIndex(workingtime => workingtime.id === workingtimeId);
      if (index !== -1) {
        workingtimes.value[index] = updatedWorkingtime;
      }
      isLoading.value = false;

      return true;
    } catch (errors) {
      error.value = 'Error when updating working time.';
      isLoading.value = false;
    }

    return false;
  };

  const deleteWorkingtime = async (workingtimeId: string): Promise<boolean> => {
    isLoading.value = false;

    try {
      await API.workingtimes.deleteWorkingtime(workingtimeId);
      workingtimes.value = workingtimes.value.filter(workingtime => workingtime.id !== workingtimeId);
      isLoading.value = false;

      return true;
    } catch (error) {
      isLoading.value = false;
    }

    return false;
  }

  return { workingtimes, isLoading, error, selectedWorkingtime, getWorkingtimes, createWorkingtime,
           updateWorkingtime, deleteWorkingtime, getCurrentUserWorkingtimes, getTeamWorkingtimes, createTeamWorkingtime };
})