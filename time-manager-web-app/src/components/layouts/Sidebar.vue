
<template>
  <nav class="pc-sidebar">
    <div class="navbar-wrapper">
      <div class="m-header flex items-center py-4 px-6 h-header-height">
        <a href="#" class="b-brand flex items-center gap-3">
          <img src="@/assets/logo.svg" class="img-fluid logo-lg" alt="logo" />
          <span class="badge bg-success-500/10 text-success-500 rounded-full theme-version"
            >v1.0.0</span
          >
        </a>
      </div>
      <div class="navbar-content h-[calc(100vh_-_74px)] py-2.5">
        <div
          class="card pc-user-card mx-[15px] mb-[15px] bg-theme-sidebaruserbg dark:bg-themedark-sidebaruserbg"
        >
          <div class="card-body !p-5">
            <div class="flex items-center">
              <img
                class="shrink-0 w-[45px] h-[45px] rounded-full"
                src="@/assets/img/user/avatar-1.jpg"
                alt="user-image"
              />
              <div class="ml-4 mr-2 grow">
                <h6 class="mb-0">Jonh Smith</h6>
                <small>Administrator</small>
              </div>
              <a
                class="shrink-0 btn btn-icon inline-flex btn-link-secondary"
                data-pc-toggle="collapse"
                href="#pc_sidebar_userlink"
              >
                <i class="text-2xl leading-none ti ti-menu-deep"></i>
              </a>
            </div>
            <div class="hidden pc-user-links" id="pc_sidebar_userlink">
              <div class="pt-3 *:flex *:items-center *:py-2 *:gap-2.5 hover:*:text-primary-500">
                <a href="#!">
                  <i class="text-lg leading-none ti ti-user"></i> <span>My Account</span>
                </a>
                <a href="#!">
                  <i class="text-lg leading-none ti ti-settings"></i>
                  <span>Settings</span>
                </a>
                <a href="#!"
                  ><i class="text-lg leading-none ti ti-lock"></i> <span>Lock Screen</span> </a
                ><a href="#!"
                  ><i class="text-lg leading-none ti ti-power"></i> <span>Logout</span></a
                >
              </div>
            </div>
          </div>
        </div>
        <ul class="pc-navbar">
          <li class="pc-item">
            <RouterLink to="/" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-dashboard"></i>
              <span class="pc-mtext">Dashboard</span>
            </RouterLink>
          </li>
          <li class="pc-item">
            <RouterLink to="/users" class="pc-link text-black">
              <i class="text-xl mr-2 ti ti-users"></i>
              <span class="pc-mtext">Users</span>
            </RouterLink>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>