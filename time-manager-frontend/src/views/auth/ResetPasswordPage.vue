<template>

  <div class="card sm:my-12 w-full max-w-[480px] border-none shadow-none">
    <div class="card-body sm:!p-10">
      <a href="#">
        <img src="../../assets/logo.svg" style="width:90px; height:auto;" class="mb-4 img-fluid" alt="img">
      </a>
      <div class="mb-4">
        <h3 class="mb-2">
          <b>Reset Password</b>
        </h3>
        <p class="text-muted">Please choose your new password</p>
      </div>
      <div class="mb-3">
        <label class="form-label">Password</label>
        <input type="password" class="form-control" id="floatingInput" placeholder="Password">
      </div>
      <div class="mb-3">
        <label class="form-label">Confirm Password</label>
        <input type="password" class="form-control" id="floatingInput1" placeholder="Confirm Password">
      </div>
      <div class="grid mt-4">
        <button type="button" class="btn btn-primary">Reset Password</button>
      </div>
    </div>
  </div>


</template>