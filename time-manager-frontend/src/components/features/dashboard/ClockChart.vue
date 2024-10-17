<script setup lang="ts">
import { onMounted, ref, watch, toRefs } from 'vue';
import { Chart } from 'chart.js/auto';
import { useClocksStore } from '@/stores/clocks';

interface TimeRange {
  start: number | null;
  end: number | null;
}

interface TimeRecord {
  date: string;
  startTime: number | null;
  endTime: number | null;
}

const props = defineProps({
  userId: String
});
const clockStore = useClocksStore();
const { clocks } = toRefs(clockStore);


const times = ref<TimeRecord[]>([]);  // Contiendra les paires (start, end) pour chaque journée
const chart = ref<any>(null); // Stocke la référence au graphique

const fetchData = async () => {
    // if (props.userId) {
        try {
            // Récupérer les données depuis l'API
            await clockStore.getClocks();
            // fonction pour ordonner les dates de clock
            const parseDate = (dateString: string) => {
                const [day, month, year] = dateString.split('/').map(Number);
                return new Date(year, month - 1, day); // Mois sont 0-indexés en JavaScript
            };

            // Fonction de tri améliorée de clock
            const sortByDate = (a: TimeRecord, b: TimeRecord) => {
                const dateA = parseDate(a.date);
                const dateB = parseDate(b.date);
                return dateA.getTime() - dateB.getTime();
            };
            if (clocks.value) {
                const groupedTimes: { [date: string]: TimeRange } = {};

            // Traiter les données pour regrouper par paires de start et end par date
                clocks.value.forEach(item => {
                    const dateTime = new Date(item.time);
                    const date = dateTime.toLocaleDateString(); // Extraire uniquement la date (jour/mois/année)
                    const time = dateTime.getHours() * 60 + dateTime.getMinutes(); // Temps en minutes depuis minuit

                    if (!groupedTimes[date]) {
                        groupedTimes[date] = { start: null, end: null };
                    }

                    // Associer chaque status true à un start et chaque status false à un end
                    if (item.status === true) {
                        groupedTimes[date].start = time;
                    } else if (item.status === false) {
                        groupedTimes[date].end = time;
                    }
                });

                // Stocker les données pour le graphique en format { date, start, end }
                times.value = Object.entries(groupedTimes)
                    .filter(([date, times]) => times.start !== null && times.end !== null)
                    .map(([date, times]) => ({
                        date,
                        startTime: times.start,
                        endTime: times.end
                    }))
                    .sort(sortByDate);

                // Créer le graphique une fois que les données sont prêtes
                createChart();
            }
        } catch (error) {
            console.error('Erreur lors de la récupération des données:', error);
        }
    // }
}

// Requête déclenchée à chaque changement de l'ID utilisateur
// watch(() => props.userId, fetchData);

onMounted(fetchData);

// Fonction pour créer le graphique
const createChart = () => {
    const ctx = document.getElementById('myChart_1') as HTMLCanvasElement;
    if (chart.value) {
        chart.value.destroy();
    }

    chart.value = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: times.value.map(time => time.date),
            datasets: [{
                label: 'Plage horaire',
                data: times.value.map(time => [time.startTime, time.endTime]),
                backgroundColor: 'rgba(255, 165, 0, 0.5)',
                borderColor: 'rgba(255, 165, 0, 1)',
                borderWidth: 2,
                borderRadius: 10,
                borderSkipped: false,
                barPercentage: 0.6,
            }]
        },
        options: {
            responsive: true,
            scales: {
            x: {
                title: {
                display: true,
                text: 'Dates',
                },
            },
            y: {
                beginAtZero: true,
                min: 0,
                max: 24 * 60, // 24 heures en minutes
                title: {
                display: true,
                text: 'Heures',
                },
                ticks: {
                    stepSize: 180, // Intervalles d'une heure
                    callback: function(value: string | number) {
                        const hours = Math.floor(Number(value) / 60);
                        const minutes = Number(value) % 60;
                        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
                    }
                },
            }
            }, // scale
            plugins: {
                tooltip: {
                    callbacks: {
                    label: function(context) {
                        const value = context.raw as [number, number];
                        const formatTime = (minutes: number) => {
                            const hours = Math.floor(minutes / 60);
                            const mins = minutes % 60;
                            return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
                        };
                        return `Plage horaire : De ${formatTime(value[0])} à ${formatTime(value[1])}`;
                    }
                    }
                }
            },
        }
    });
};
</script>

<template>
  <div>
    <canvas id="myChart_1" height="175"></canvas>
  </div>
</template>
