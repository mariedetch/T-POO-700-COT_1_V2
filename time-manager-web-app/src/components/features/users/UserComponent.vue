<script setup lang="ts">
import { onMounted, ref } from 'vue';
import Chart from 'chart.js/auto';
import axios from 'axios';

const times = ref([]);  // Contiendra les dates et les plages horaires
const chart = ref(null); // Stocke la référence au graphique

onMounted(async () => {
  try {
    // Récupérer les données depuis l'API
    const res = await axios.get("http://127.0.0.1:4000/api/workingtime/0fabfdfb-f80d-402f-aef4-878c0ff31dcf");
    const responseApi = res.data;

    if (responseApi && responseApi.data) {
      // Traiter les données pour extraire les dates et les heures
      times.value = responseApi.data.map(item => {
        const start = new Date(item.start);  // On convertit `start` en objet Date
        const end = new Date(item.end);      // On convertit `end` en objet Date
        
        return {
          date: start.toLocaleDateString(),  // Extraire uniquement la date (jour/mois/année)
          startTime: start.getHours() + start.getMinutes() / 60, // Extraire l'heure de début (en heures décimales)
          endTime: end.getHours() + end.getMinutes() / 60, // Extraire l'heure de fin (en heures décimales)
        };
      });

      // Créer le graphique une fois que les données sont prêtes
      createChart();
    }
  } catch (error) {
    console.error('Erreur lors de la récupération des données:', error);
  }
});

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
        borderWidth: 1, // Épaisseur de la bordure
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
          max: 24, // Heure maximum (24h format)
          title: {
            display: true,
            text: 'Heures', // Titre de l'axe des ordonnées (représentant les heures)
          },
          ticks: {
            stepSize: 3, // Intervalles d'une heure sur l'axe des ordonnées
            callback: function(value) {
              // Affiche les heures en format H:MM (par exemple, 14:30)
              const hours = Math.floor(value);
              const minutes = (value % 1) * 60;
              return hours + ':' + (minutes < 10 ? '0' : '') + minutes;
            }
          },
        }
      }
    }
  });
};
</script>

<template>
  <h2>Plage horaire par date</h2>
  <div>
    <canvas id="myChart" width="500" height="300"></canvas>
  </div>
</template>
