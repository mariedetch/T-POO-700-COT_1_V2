<script setup lang="ts">
import { onMounted, ref, toRefs } from 'vue';
import Chart from 'chart.js/auto';

import { useWorkingtimesStore } from '@/stores/workingtimes';
import { useClocksStore } from '@/stores/clocks';

interface TimeData {
  date: string;
  startTime: number | null;
  endTime: number | null;
}


interface GroupedTimes {
  [date: string]: {
    start: number | null;
    end: number | null;
  };
}

const workingStore = useWorkingtimesStore();
const { workingtimes } = toRefs(workingStore);

const clockStore = useClocksStore();
const { clocks } = toRefs(clockStore);

const times = ref<TimeData[]>([]); // Contiendra les dates et les plages horaires pour workingTimes
const times_clock = ref<TimeData[]>([]); // Contiendra les dates et les plages horaires pour clock

const chart = ref<Chart | null>(null); // Stocke la référence au graphique

const fetchData = async () => {
    try {
        // Récupérer les données depuis l'API
        await workingStore.getWorkingtimes()
        await clockStore.getClocks();

        // fonction pour ordonner les dates de clock
        const parseDate = (dateString: string) => {
            const [day, month, year] = dateString.split('/').map(Number);
            return new Date(year, month - 1, day); // Mois sont 0-indexés en JavaScript
        };

        // Fonction de tri améliorée de clock
        const sortByDate = (a: TimeData, b: TimeData) => {
            const dateA = parseDate(a.date);
            const dateB = parseDate(b.date);
            return dateA.getTime() - dateB.getTime();
        };
        
        if (workingtimes.value && clocks.value) {
        // Traiter les données pour extraire les dates et les heures
        times.value = workingtimes.value.map(item => {
            const start = new Date(item.start);  // On convertit `start` en objet Date
            const end = new Date(item.end);      // On convertit `end` en objet Date
            
            return {
            date: start.toLocaleDateString(),  // Extraire uniquement la date (jour/mois/année)
            startTime: start.getHours()*60 + start.getMinutes(),
            endTime: end.getHours() * 60 + end.getMinutes(),
            };
        });

        // ======================== Traitement clocks ============
        const groupedTimes: GroupedTimes = {};

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
        times_clock.value = Object.entries(groupedTimes)
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

};

onMounted(fetchData);

// Fonction pour créer le graphique
const createChart = () => {
  const ctx = document.getElementById('myChart_2') as HTMLCanvasElement; // Sélection du canvas
  if (chart.value) {
    chart.value.destroy(); // Si un graphique existe déjà, on le détruit pour en recréer un nouveau
  }

  // Créer un graphique avec des bandes allant de l'heure de début à l'heure de fin
  chart.value = new Chart(ctx, {
    type: 'line', // Type de graphique (bar chart)
    data: {
      labels: times.value.map(time => time.date), // Les dates en abscisse
      datasets: [
        {
            label: 'Durée de travail théorique', // Légende
            data: times.value.map(time => (time.endTime ?? 0) - (time.startTime ?? 0)), // Les plages horaires en ordonnée
            backgroundColor: 'rgba(75, 192, 192, 0.5)', // Couleur des barres
            borderColor: 'rgba(75, 192, 192, 1)', // Couleur de la bordure des barres
            borderWidth: 2, // Epaisseur de la ligne
            tension: 0.3, // Lissage de la ligne
            fill: false, // Pas de remplissage sous la ligne
            pointRadius: 4, // Taille des points sur la ligne
            pointHoverRadius: 8, // Taille des points au survol
        },
        {
            label: 'Durée de travail réelle', // Légende
            data: times_clock.value.map(clock => (clock.endTime ?? 0) - (clock.startTime ?? 0)), // Les plages horaires en ordonnée
            backgroundColor: 'rgba(255, 99, 132, 0.5)', // Couleur des barres
            borderColor: 'rgba(255, 99, 132, 1)', // Couleur de la bordure des barres
            borderWidth: 2, // Epaisseur de la ligne
            tension: 0.3, // Lissage de la ligne
            fill: false, // Pas de remplissage sous la ligne
            pointRadius: 4, // Taille des points sur la ligne
            pointHoverRadius: 8, // Taille des points au survol           
        }
        
      ]

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
                        const minutes = (value as number) % 60;
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
                        return `${hours.toString().padStart(2, '0')}h${mins.toString().padStart(2, '0')}`;
                    };
                    return `Durée : ${formatTime(value)}`;
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
    <canvas id="myChart_2" height="175"></canvas>
  </div>
</template>
