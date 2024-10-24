<script setup lang="ts">
import * as echarts from 'echarts'
import { onMounted } from 'vue'

const initChart2 = async () => {
  const chartDom = document.getElementById('my-chart-2');
  const myChart = echarts.init(chartDom);

  const option = {
    legend: {},
    tooltip: {},
    dataset: {
      source: [
        ['product', '2015', '2016', '2017'],
        ['Matcha Latte', 43.3, 85.8, 93.7],
        ['Milk Tea', 83.1, 73.4, 55.1],
        ['Cheese Cocoa', 86.4, 65.2, 82.5],
        ['Walnut Brownie', 72.4, 53.9, 39.1]
      ]
    },
    xAxis: { type: 'category' },
    yAxis: {},
    // Declare several bar series, each will be mapped
    // to a column of dataset.source by default.
    series: [{ type: 'bar' }, { type: 'bar' }, { type: 'bar' }]
  };

  myChart.setOption(option);
};

onMounted(async () => {
  initChart2()
})
</script>

<template>
  <div class="card">
    <div class="card-body">
      <div class="col-span-12 lg:col-span-9" id="my-chart-2" style="width: 100%; height: 335px;"></div>
    </div>
  </div>
</template>