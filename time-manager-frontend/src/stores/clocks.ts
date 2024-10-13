import { API } from "@/services";
import type { Clock } from "@/services/clocks/types";
import { defineStore } from "pinia";
import { ref } from "vue";

export const useClocksStore = defineStore('clocks', () => {
  const clocks = ref<Clock[]>([]);
  const userId = import.meta.env.VITE_DEFAULT_USER;
  const startDateTime = ref<Date | null>(null);
  const clockIn = ref<Boolean>(false);
  const error = ref<string | null>(null);

  const getClocks = async (userId: string | null = null) => {
    error.value = null;

    try {
      clocks.value = (await API.clocks.getClocks(userId)).data.data;
    } catch (errors) {
      error.value = 'Error when retrieving users.';
    }
  };

  const clock = async () => {
    error.value = null;

    API.clocks.createClock().then((response) => {
      const clock = response.data.data;
      console.log(clock);

      startDateTime.value = clock.status ? clock.time : null;
      clockIn.value = clock.status;
    })
    .catch((errors) => {
      error.value = 'Erreur lors de la création de l\'utilisateur.';
    });
  };

  const getLatestClock = async () => {
    error.value = null;

    API.clocks.getClock().then((response) => {
      const clock = response.data.data;

      if (clock) {
        startDateTime.value = clock.status ? clock.time : null;
        clockIn.value = clock.status;
      } else {
        startDateTime.value = null;
        clockIn.value = false;
      }
    })
    .catch((errors) => {
      error.value = 'Erreur lors de la création de l\'utilisateur.';
    });
  };

  return { clocks, startDateTime, clockIn, error, clock, getClocks, getLatestClock };
});
