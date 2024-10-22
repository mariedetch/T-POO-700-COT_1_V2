<template>
  <div class="container">
    <div class="card error-card bg-transparent dark:bg-transparent shadow-none border-none">
      <div class="card-body">
        <div class="error-image-block">
          <img class="img-fluid mx-auto" src="@/assets/img/img-error-500.svg" alt="img" />
        </div>
        <div class="text-center">
          <h1 class="mt-4"><b>Forbidden Access</b></h1>
          <p class="mt-2 mb-4 text-sm text-muted">
            Sorry, you do not have the permission to access this page.
          </p>
          <RouterLink to="/" class="btn btn-primary mb-3">Go back to Home</RouterLink>
        </div>
      </div>
    </div>
  </div>
</template>