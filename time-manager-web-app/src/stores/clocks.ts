import { API } from "@/services";
import { defineStore } from "pinia";
import { ref } from "vue";

export const useClocksStore = defineStore('clocks', () => {
  const startDateTime = ref<Date | null>(null);
  const clockIn = ref<Boolean>(false);
  const error = ref<string | null>(null);

  const clock = async () => {
    error.value = null;

    API.cloks.createClock().then((response) => {
      const clock = response.data.data;
      console.log(clock);

      if (clock.status) {
        startDateTime.value = null;
      }
      clockIn.value = clock.status;
    })
    .catch((error) => {
      error.value = 'Erreur lors de la création de l\'utilisateur.';
    });
  };

  return { startDateTime, clockIn, error, clock };
});
