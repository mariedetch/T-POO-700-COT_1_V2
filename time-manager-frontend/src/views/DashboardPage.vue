<script setup lang="ts">
import ClockChart from '@/components/features/dashboard/ClockChart.vue'
import WorkingChart from '@/components/features/dashboard/WorkingChart.vue'
import Linechart from '@/components/features/dashboard/Linechart.vue'
</script>

<template>
  <div class="grid grid-cols-12 gap-x-6">
    <!-- First chart -->
    <div class="col-span-12 lg:col-span-6">
      <div class="card">
        <div class="card-body">
          <div class="flex items-center justify-between">
            <div class="flex items-center justify-between">
              <h5 class="mb-0">Working time de l'employé</h5>
              <div class="dropdown">
                <a class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary dropdown-toggle arrow-none" href="#" data-pc-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <i class="ti ti-dots text-lg leading-none"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-end">
                  <a class="dropdown-item" href="#">Today</a>
                  <a class="dropdown-item" href="#">Weekly</a>
                  <a class="dropdown-item" href="#">Monthly</a>
                </div>
              </div>
            </div>
          </div>
          <WorkingChart />
        </div>
      </div>
    </div> 

    <!-- Second chart -->
    <div class="col-span-12 lg:col-span-6">
      <div class="card">
        <div class="card-body">
          <div class="flex items-center justify-between">
            <div class="flex items-center justify-between">
              <h5 class="mb-0">Clocking de l'employé</h5>
              <div class="dropdown">
                <a class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary dropdown-toggle arrow-none" href="#" data-pc-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <i class="ti ti-dots text-lg leading-none"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-end">
                  <a class="dropdown-item" href="#">Today</a>
                  <a class="dropdown-item" href="#">Weekly</a>
                  <a class="dropdown-item" href="#">Monthly</a>
                </div>
              </div>
            </div>
          </div>
          <ClockChart />
        </div>
      </div>
    </div>

    <!-- third chart -->
    <div class="col-span-12 lg:col-span-6">
      <div class="card">
        <div class="card-body">
          <div class="flex items-center justify-between">
            <div class="flex items-center justify-between">
              <h5 class="mb-0">Durée de travail de l'employé</h5>
              <div class="dropdown">
                <a class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary dropdown-toggle arrow-none" href="#" data-pc-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  <i class="ti ti-dots text-lg leading-none"></i>
                </a>
                <div class="dropdown-menu dropdown-menu-end">
                  <a class="dropdown-item" href="#">Today</a>
                  <a class="dropdown-item" href="#">Weekly</a>
                  <a class="dropdown-item" href="#">Monthly</a>
                </div>
              </div>
            </div>
          </div>
          <Linechart />
        </div>
      </div>
    </div>

    <!-- End third chart -->

  </div>
</template>