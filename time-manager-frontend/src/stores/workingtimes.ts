import { API } from "@/services";
import type { Workingtime, WorkingtimeRequest } from "@/services/workingtimes/types";
import { defineStore } from "pinia"
import { ref } from "vue"

export const useWorkingtimesStore = defineStore('workingtimes', () => {
  const workingtimes = ref<Workingtime[]>([]);
  const selectedWorkingtime = ref<Workingtime | null>(null);
  const isLoading = ref(false);
  const error = ref<string | null>(null);

  const getWorkingtimes = async (userID: string) => {
    isLoading.value = true;
    error.value = null;

    try {
        workingtimes.value = (await API.workingtimes.getWorkingtimes(userID)).data.data;
    } catch (errors) {
      error.value = 'Error during the working times recovering';
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

  return { workingtimes, isLoading, error, selectedWorkingtime, getWorkingtimes, createWorkingtime, updateWorkingtime, deleteWorkingtime };
})