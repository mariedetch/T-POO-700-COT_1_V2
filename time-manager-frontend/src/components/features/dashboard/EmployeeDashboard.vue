<script setup lang="ts">
import * as echarts from 'echarts';
import { onMounted } from 'vue';

const props = defineProps({
  userId: String
});

const initChart = async () => {
  const chartDom = document.getElementById('my-chart');
  const myChart = echarts.init(chartDom);

  const option = {
    title: {
      text: 'Ponctuality Data',
      subtext: 'Comparative punctuality rates',
      left: 'center'
    },
    tooltip: {
      trigger: 'item'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: 'Access From',
        type: 'pie',
        radius: '50%',
        data: [
          { value: 1048, name: 'Presence' },
          { value: 735, name: 'Absence' },
          { value: 580, name: 'Delay' }
        ],
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }
    ]
  };

  myChart.setOption(option);
};

const initChart2 = async () => {
  const chartDom = document.getElementById('my-chart-2');
  const myChart = echarts.init(chartDom);

  const option = {
    legend: {},
    tooltip: {},
    dataset: {
      source: [
        ['product', 'Scheduled Hours', 'Hours worked'],
        ['Matcha Latte', 43.3, 85.8],
        ['Milk Tea', 83.1, 73.4],
        ['Cheese Cocoa', 86.4, 65.2],
        ['Walnut Brownie', 72.4, 53.9]
      ]
    },
    xAxis: { type: 'category' },
    yAxis: {},
    series: [{ type: 'bar' }, { type: 'bar' }]
  };

  myChart.setOption(option);
};

onMounted(async () => {
  initChart()
  initChart2()
})
</script>

<template>
  <main>
    <div class="grid grid-cols-12 gap-x-6">
      <div class="col-span-12 xl:col-span-4 md:col-span-6">
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Daily hours worked</h6>
            <h4 class="mb-3">
              4,42,236
              <span class="badge bg-primary-500/10 border border-primary-500 text-primary-500"
                ><i class="ti ti-trending-up"></i> 59.3%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled daily hours</p>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Weekly hours worked</h6>
            <h4 class="mb-3">
              78,250
              <span class="badge bg-success-500/10 border border-success-500 text-success-500"
                ><i class="ti ti-trending-up"></i> 70.5%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled weekly hours</p>
          </div>
        </div>
        <div class="card">
          <div class="card-body">
            <h6 class="mb-2 font-normal text-muted">Monthly hours worked</h6>
            <h4 class="mb-3">
              18,800
              <span class="badge bg-warning-500/10 border border-warning-500 text-warning-500"
                ><i class="ti ti-trending-down"></i> 27.4%</span
              >
            </h4>
            <p class="mb-0 text-muted text-sm"><strong>VS</strong> Scheduled monthly hours</p>
          </div>
        </div>
      </div>
      <div class="col-span-12 xl:col-span-8 md:col-span-12">
        <div class="card">
          <div class="card-header flex items-center justify-between">
            <h5 class="mb-0">Hours worked vs. hours planned</h5>
            <select class="form-select w-auto">
              <option>Today</option>
              <option>Weekly</option>
              <option :selected="true">Monthly</option>
            </select>
          </div>
          <div class="card-body">
            <div class="col-span-12 lg:col-span-9" id="my-chart-2" style="width: 100%; height: 335px;"></div>
          </div>
        </div>
      </div>

      <div class="col-span-12 lg:col-span-7 flex flex-col gap-y-4">
        <div class="card">
          <div class="card-body">
            <div class="col-span-12 lg:col-span-9" id="my-chart" style="width: 100%; height: 400px;"></div>
          </div>
        </div>
      </div>

      <div class="col-span-12 md:col-span-5">
        <div class="card">
          <h3 class="mt-4 text-center f-46"><b>Coming Soon</b></h3>
          <div
            class="timer-block mt-4 flex items-center justify-center gap-6 flex-wrap leading-none font-semibold *:w-20 *:h-20 *:rounded-xl *:inline-flex *:items-center *:justify-center *:card *:text-2xl"
            id="timer-block"
          >
            <div>1</div>
            <div>23</div>
            <div>55</div>
            <div>26</div>
          </div>
        </div>
        <div class="card">
          <div class="card-header flex items-center justify-between">
            <h5 class="mb-0">Your day's arrivals and departures</h5>
          </div>
          <div class="card-body">
            <ul class="list-unstyled task-list relative pl-[30px] *:mb-3">
              <li
                class="absolute h-full w-0.5 top-0 left-2.5 z-10 bg-theme-border dark:bg-themedark-border"
              ></li>
              <li
                class="absolute rounded-full p-0.5 bottom-0 !mb-0 left-[3px] min-w-[15px] min-h-[15px] z-20 bg-theme-border dark:bg-themedark-border"
              ></li>
              <li>
                <i
                  class="feather icon-check font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-success-500 text-white"
                ></i>
                <p class="mb-1">8:50</p>
                <p class="text-muted">
                  Call to customer
                  <span class="text-primary"><a href="#!" class="text-primary">Jacob</a> </span>and
                  discuss the
                </p>
              </li>
              <li>
                <i
                  class="font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-primary-500 text-white"
                ></i>
                <p class="mb-1">Sat, 5 Mar</p>
                <p class="text-muted">Design mobile Application</p>
              </li>
              <li>
                <i
                  class="font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-danger-500 text-white"
                ></i>
                <p class="mb-1">Sun, 17 Feb</p>
                <p class="text-muted">
                  <span><a href="#!" class="text-primary-500">Jeny</a></span> assign you a task
                  <span><a href="#!" class="text-primary-500">Mockup Design.</a></span>
                </p>
              </li>
              <li>
                <i
                  class="font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-warning-500 text-white"
                ></i>
                <p class="mb-1">Sat, 18 Mar</p>
                <p class="text-muted">Design logo</p>
              </li>
              <li class="pb-3 mb-2">
                <i
                  class="font-semibold rounded-full p-0.5 absolute left-[3px] min-w-[15px] min-h-[15px] z-20 bg-success-500 text-white"
                ></i>
                <p class="mb-1">Sat, 22 Mar</p>
                <p class="text-muted">Design mobile Application</p>
              </li>
            </ul>
          </div>
        </div>
      </div>

    </div>
  </main>
</template>