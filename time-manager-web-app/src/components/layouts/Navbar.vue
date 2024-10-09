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
          <li class="dropdown pc-h-item header-user-profile">
            <a
              class="pc-head-link dropdown-toggle arrow-none me-0"
              data-pc-toggle="dropdown"
              href="#"
              role="button"
              aria-haspopup="false"
              data-pc-auto-close="outside"
              aria-expanded="false"
              ><img
                src="@/assets/img/user/avatar-1.jpg"
                alt="user-image"
                class="user-avtar w-10 h-10 rounded-full"
            /></a>
            <div class="dropdown-menu dropdown-user-profile dropdown-menu-end pc-h-dropdown p-2">
              <div class="dropdown-header flex items-center justify-between py-4 px-5">
                <h5 class="m-0">Profile</h5>
              </div>
              <div class="dropdown-body py-4 px-5">
                <div
                  class="profile-notification-scroll position-relative"
                  style="max-height: calc(100vh - 225px)"
                >
                  <div class="flex mb-1 items-center">
                    <div class="shrink-0">
                      <img
                        src="@/assets/img/user/avatar-1.jpg"
                        alt="user-image"
                        class="w-10 rounded-full"
                      />
                    </div>
                    <div class="grow ms-3">
                      <h6 class="mb-1">Carson Darrin 🖖</h6>
                      <span
                        ><a
                          href="/cdn-cgi/l/email-protection"
                          class="__cf_email__"
                          data-cfemail="690a081b1a0607470d081b1b0007290a060419080710470006"
                          >[email&#160;protected]</a
                        ></span
                      >
                    </div>
                  </div>
                  <hr class="border-secondary-500/10 my-4" />
                  <div class="card">
                    <div class="card-body !py-4">
                      <div class="flex items-center justify-between">
                        <h5 class="mb-0 inline-flex items-center">
                          <i class="text-2xl mr-2 ti ti-bell"></i>
                          Notification
                        </h5>
                        <label class="inline-flex items-center cursor-pointer"
                          ><input type="checkbox" value="" class="sr-only peer" />
                          <div
                            class="relative w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 dark:peer-focus:ring-blue-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-blue-600"
                          ></div>
                        </label>
                      </div>
                    </div>
                  </div>
                  <p class="text-span mb-3">Manage</p>
                  <a href="#" class="dropdown-item"
                    ><span
                      ><i class="text-xl mr-2 ti ti-settings"></i>
                      <span>Settings</span>
                    </span></a
                  ><a href="#" class="dropdown-item"
                    ><span
                      ><i class="text-xl mr-2 ti ti-lock"></i>
                      <span>Change Password</span></span
                    ></a
                  >
                  <hr class="border-secondary-500/10 my-4" />
                  <p class="text-span mb-3">Teams</p>
                  <a href="#" class="dropdown-item"
                    ><span
                      ><i class="text-xl mr-2 ti ti-users"></i>
                      <span>UI Design team</span></span
                    >
                    <div
                      dir="ltr"
                      class="flex -space-x-2 overflow-hidden *:flex *:items-center *:justify-center *:rounded-full *:w-[30px] *:h-[30px] hover:*:z-10 *:border *:border-2 *:border-white"
                    >
                      <img
                        src="@/assets/img/user/avatar-1.jpg"
                        alt="user-image"
                        class="avtar"
                      />
                      <span class="avtar bg-danger text-white">K</span>
                      <span class="avtar bg-success text-white"
                        ><svg class="pc-icon m-0">
                          <use xlink:href="#custom-user"></use>
                        </svg> </span
                      ><span class="avtar bg-theme-cardbg dark:bg-themedark-cardbg overflow-hidden"
                        ><span
                          class="flex items-center justify-center w-full h-full bg-primary-500/10 text-primary-500"
                          >+2</span
                        ></span
                      >
                    </div> </a
                  ><a href="#" class="dropdown-item"
                    ><span
                      ><i class="text-xl mr-2 ti ti-users"></i>
                      <span>Friends Groups</span></span
                    >
                    <div
                      dir="ltr"
                      class="flex -space-x-2 overflow-hidden *:flex *:items-center *:justify-center *:rounded-full *:w-[30px] *:h-[30px] hover:*:z-10 *:border *:border-2 *:border-white"
                    >
                      <img
                        src="@/assets/img/user/avatar-1.jpg"
                        alt="user-image"
                        class="avtar"
                      />
                      <span class="avtar bg-danger text-white">K</span>
                      <span class="avtar bg-success text-white"
                        ><svg class="pc-icon m-0">
                          <use xlink:href="#custom-user"></use></svg
                      ></span>
                    </div> </a
                  >
                  <hr class="border-secondary-500/10 my-4" />
                  <div class="grid mb-3">
                    <button class="btn btn-primary flex items-center justify-center">
                      <i class="text-xl mr-2 ti ti-logout"></i>
                      Logout
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </header>
</template>