<script setup lang="ts">
  import ClockManager from "@/components/features/clocks/ClockManager.vue";
</script>

<template>
  <header class="pc-header">
    <div class="header-wrapper flex max-sm:px-[15px] px-[25px] grow">
      <!-- [Mobile Media Block] start -->
      <div class="me-auto pc-mob-drp">
        <ul class="inline-flex *:min-h-header-height *:inline-flex *:items-center">
          <li class="pc-h-item max-md:hidden md:inline-flex">
            <form class="form-search relative">
              <i class="search-icon absolute top-[14px] left-[15px]"
                ><svg class="pc-icon w-4 h-4">
                  <use xlink:href="#custom-search-normal-1"></use>
                </svg> </i
              ><input
                type="search"
                class="form-control px-2.5 pr-3 pl-10 w-[198px] leading-none"
                placeholder="Ctrl + K"
              />
            </form>
          </li>
        </ul>
      </div>
      <!-- [Mobile Media Block end] -->
      <div class="ms-auto">
        <ul class="inline-flex *:min-h-header-height *:inline-flex *:items-center">
          <ClockManager />
          <li class="dropdown pc-h-item">
            <a
              class="pc-head-link dropdown-toggle me-0"
              data-pc-toggle="dropdown"
              href="#custom-setting-2"
              role="button"
              aria-haspopup="false"
              aria-expanded="false"
              >
              <i class="ti ti-settings"></i>
            </a>
            <div class="dropdown-menu dropdown-menu-end pc-h-dropdown">
              <a href="#!" class="dropdown-item"
                ><i class="ti ti-user"></i> <span>My Account</span> </a
              ><a href="#!" class="dropdown-item"
                ><i class="ti ti-settings"></i> <span>Settings</span> </a
              ><a href="#!" class="dropdown-item"
                ><i class="ti ti-headset"></i> <span>Support</span> </a
              ><a href="#!" class="dropdown-item"
                ><i class="ti ti-lock"></i> <span>Lock Screen</span> </a
              ><a href="#!" class="dropdown-item"
                ><i class="ti ti-power"></i> <span>Logout</span></a
              >
            </div>
          </li>
          <li class="dropdown pc-h-item">
            <a
              class="pc-head-link dropdown-toggle me-0"
              data-pc-toggle="dropdown"
              href="#"
              role="button"
              aria-haspopup="false"
              aria-expanded="false"
              ><i class="ti ti-bell"></i>
              <span class="badge bg-success-500 text-white rounded-full z-10 absolute right-0 top-0"
                >3</span
              ></a
            >
          </li>
        </ul>
      </div>
    </div>
  </header>
</template>