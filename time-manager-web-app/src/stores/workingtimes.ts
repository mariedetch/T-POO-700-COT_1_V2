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
        console.log("Working times has been successfully recovered :");
    } catch (errors) {
      error.value = 'Error during the working times recovering';
    } finally {
      isLoading.value = false;
    }
  };

  const createWorkingtime= async (userID: string, data: WorkingtimeRequest) => {
    isLoading.value = true;
    error.value = null;

    API.workingtimes.createWorkingtime(userID, data).then((response) => {
      workingtimes.value.push(response.data.data);
      console.log("Working time successfully created");
    })
    .catch((error) => {
      error.value = 'Error during working time creation :';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const updateWorkingtime = async (workingtimeId: string, data: Partial<WorkingtimeRequest>) => {
    isLoading.value = true;
    error.value = null;

    API.workingtimes.updateWorkingtime(workingtimeId, data).then((response) => {
      const updatedWorkingtime = response.data.data;
      const index = workingtimes.value.findIndex(workingtime => workingtime.id === workingtimeId);
        if (index !== -1) {
          workingtimes.value[index] = updatedWorkingtime;
        }
    })
    .catch((error) => {
      error.value = 'Creation failed for working time';
    })
    .finally(() => {
      isLoading.value = false;
    });
  };

  const deleteWorkingtime = async (workingtimeId: string) => {
    isLoading.value = false;
    try {
      await API.workingtimes.deleteWorkingtime(workingtimeId);
      workingtimes.value = workingtimes.value.filter(workingtime => workingtime.id !== workingtimeId);
    } catch (error) {
      isLoading.value = false;
    }
  }

  return { workingtimes, isLoading, error, selectedWorkingtime, getWorkingtimes, createWorkingtime, updateWorkingtime, deleteWorkingtime };
})