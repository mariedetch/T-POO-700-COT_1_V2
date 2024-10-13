<script setup lang="ts">
import { onMounted, ref, watch, toRefs } from 'vue';
import Chart from 'chart.js/auto';
import axios from 'axios';
import { useClocksStore } from '@/stores/clocks';

const props = defineProps({
  userId: String
});
const clockStore = useClocksStore();
const { clocks } = toRefs(clockStore);


const times = ref([]);  // Contiendra les paires (start, end) pour chaque journée
const chart = ref(null); // Stocke la référence au graphique

const fetchData = async () => {
    // if (props.userId) {
        try {
            // Récupérer les données depuis l'API
            await clockStore.getClocks();

            if (clocks.value) {
                const groupedTimes = {};

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
                    .sort((a, b) => new Date(a.date) - new Date(b.date));

            // Créer le graphique une fois que les données sont prêtes
            createChart();
            }
        } catch (error) {
            console.error('Erreur lors de la récupération des données:', error);
        }
    // }
}

// Requête déclenchée à chaque changement de l'ID utilisateur
watch(() => props.userId, fetchData);

onMounted(fetchData);

// Fonction pour créer le graphique
const createChart = () => {
    const ctx = document.getElementById('myChart_2'); // Sélection du canvas
    if (chart.value) {
    chart.value.destroy(); // Si un graphique existe déjà, on le détruit pour en recréer un nouveau
    }

    chart.value = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: times.value.map(time => time.date),
        datasets: [{
            label: 'Plage horaire',
            data: times.value.map(time => [time.startTime, time.endTime]),
            backgroundColor: 'rgba(75, 192, 192, 0.5)',
            borderColor: 'rgba(75, 192, 192, 1)',
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
                callback: function(value) {
                    const hours = Math.floor(value / 60);
                    const minutes = value % 60;
                    return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
                }
            },
        }
        }, // scale
        plugins: {
            tooltip: {
                callbacks: {
                label: function(context) {
                    const value = context.raw;
                    const formatTime = (minutes) => {
                        const hours = Math.floor(minutes / 60);
                        const mins = minutes % 60;
                        return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
                    };
                    return `Plage horaire : De ${formatTime(value[0])} à ${formatTime(value[1])}`;
                }
                }
            }
        }, // plugins 
    } // option 
    });
};
</script>

<template>
  <div>
    <canvas id="myChart_2" width="500" height="300"></canvas>
  </div>
</template>
