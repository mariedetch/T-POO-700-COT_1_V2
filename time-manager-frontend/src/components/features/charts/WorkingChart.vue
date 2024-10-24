<script setup lang="ts">
import { onMounted, ref, watch, toRefs } from 'vue';
import Chart from 'chart.js/auto';

import { useWorkingtimesStore } from '@/stores/workingtimes';

const props = defineProps({
  userId: String
});

interface TimeData {
  date: string;
  startTime: number;
  endTime: number;
}

const workingStore = useWorkingtimesStore();
const { workingtimes } = toRefs(workingStore);

const times = ref<TimeData[]>([]); // Contiendra les dates et les plages horaires
const chart = ref<Chart | null>(null); // Stocke la référence au graphique

const fetchData = async () => {
    // if (props.userId) {
        try {
            // Récupérer les données depuis l'API
            await workingStore.getWorkingtimes()

            if (workingtimes.value) {
            // Traiter les données pour extraire les dates et les heures
            times.value = workingtimes.value.map(item => {
                const start = new Date(item.start);  // On convertit `start` en objet Date
                const end = new Date(item.end);      // On convertit `end` en objet Date
                
                return {
                date: start.toLocaleDateString(),  // Extraire uniquement la date (jour/mois/année)
                startTime: start.getHours()*60 + start.getMinutes(), // Extraire l'heure de début (en heures décimales)
                endTime: end.getHours() * 60 + end.getMinutes(), // Extraire l'heure de fin (en heures décimales)
                };
            });

            // Créer le graphique une fois que les données sont prêtes
            createChart();
            }
        } catch (error) {
            console.error('Erreur lors de la récupération des données:', error);
        }
    //}// fin if 

};

// Requête déclenchée à chaque changement de l'ID utilisateur
// watch(() => props.userId, fetchData);

onMounted(fetchData);

// Fonction pour créer le graphique
const createChart = () => {
  const ctx = document.getElementById('myChart') as HTMLCanvasElement; // Sélection du canvas
  if (chart.value) {
    chart.value.destroy(); // Si un graphique existe déjà, on le détruit pour en recréer un nouveau
  }

  // Créer un graphique avec des bandes allant de l'heure de début à l'heure de fin
  chart.value = new Chart(ctx, {
    type: 'bar', // Type de graphique (bar chart)
    data: {
      labels: times.value.map(time => time.date), // Les dates en abscisse
      datasets: [{
        label: 'Plage horaire', // Légende
        data: times.value.map(time => [time.startTime, time.endTime]), // Les plages horaires en ordonnée
        backgroundColor: 'rgba(75, 192, 192, 0.5)', // Couleur des barres
        borderColor: 'rgba(75, 192, 192, 1)', // Couleur de la bordure des barres
        borderWidth: 2, // Epaisseur de bordure
        borderRadius:10,
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
                text: 'Dates', // Titre de l'axe des abscisses
            },
            },
            y: {
            beginAtZero: true, // Commence l'échelle à 0
            min: 0, // Heure minimum sur l'axe des ordonnées
            max: 24*60, // Heure maximum (24h format)
            title: {
                display: true,
                text: 'Heures', // Titre de l'axe des ordonnées (représentant les heures)
            },
            ticks: {
                stepSize: 180, // Intervalles d'une heure
                    callback: function(value) {
                        const hours = Math.floor(value as number / 60);
                        const minutes = (value as number )% 60;
                        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
                    }
            }, // ticks
            }
        }, // scale
        plugins: {
            tooltip: {
                callbacks: {
                label: function(context: any) {
                    const value = context.raw;
                    const formatTime = (minutes: number) => {
                        const hours = Math.floor(minutes / 60);
                        const mins = minutes % 60;
                        return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
                    };
                    return `Plage horaire : De ${formatTime(value[0])} à ${formatTime(value[1])}`;
                }
                }
            }
        }, //
    } // options
  });
};
</script>

<template>
  <div>
    <canvas id="myChart" height="175"></canvas>
  </div>
</template>
