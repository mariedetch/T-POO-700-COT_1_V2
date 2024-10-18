<template>

  <div class="auth-main relative">
    <div class="auth-wrapper v2 flex items-center w-full h-full min-h-screen">
      <div class="auth-sidecontent"><img src="../../assets/img/authentication/img-auth-sideimg.jpg" alt="images"
          class="img-fluid h-screen hidden lg:block"></div>
      <div
        class="auth-form flex items-center justify-center grow flex-col min-h-screen bg-cover relative p-6 bg-theme-cardbg dark:bg-themedark-cardbg">
        <div class="card sm:my-12 w-full max-w-[480px] border-none shadow-none">
          <RouterView />
        </div>
      </div>
    </div>
  </div>

</template>