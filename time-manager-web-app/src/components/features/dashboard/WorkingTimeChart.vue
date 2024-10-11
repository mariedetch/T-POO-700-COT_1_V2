<script setup>
import { onMounted, ref, watch } from 'vue';
import Chart from 'chart.js/auto';
import axios from 'axios';

const props = defineProps({
  userId: String
});

const times = ref([]);  // Contiendra les dates et les plages horaires
const chart = ref(null); // Stocke la référence au graphique

const fetchData = async () => {
    if (props.userId) {
        try {
            // Récupérer les données depuis l'API
            const res = await axios.get(`http://127.0.0.1:4000/api/workingtime/${props.userId}`);
            const responseApi = res.data;

            if (responseApi && responseApi.data) {
            // Traiter les données pour extraire les dates et les heures
            times.value = responseApi.data.map(item => {
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
    }// fin if 

};

// Requête déclenchée à chaque changement de l'ID utilisateur
watch(() => props.userId, fetchData);

onMounted(fetchData);

// Fonction pour créer le graphique
const createChart = () => {
  const ctx = document.getElementById('myChart'); // Sélection du canvas
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
                        const hours = Math.floor(value / 60);
                        const minutes = value % 60;
                        return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
                    }
            }, // ticks
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
        }, //
    } // options
  });
};
</script>

<template>
  <h2>Working time de l'employé {{ props.userId ? props.userId.slice(0, 6) + '...' : '...' }}</h2>
  <div>
    <canvas id="myChart" width="500" height="300"></canvas>
  </div>
</template>
