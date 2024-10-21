<template>
    <div class="table-responsive">
      <table class="table table-hover" id="pc-dt-simple">
        <thead>
          <tr>
            <th>UserName</th>
            <th>Email</th>
            <th>Rank</th>
            <th class="text-center">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <div class="flex items-center">
                <div class="grow ltr:ml-3 rtl:mr-3">
                  <h6 class="mb-0">Daniel</h6>
                </div>
              </div>
            </td>
            <td>Danielagouta@gmail.com</td>
            <td> <span class = "badge border border-primary text-primary-500 bg-primary-500/10 rounded-full text-sm">Employee</span></td>
            <td class="text-center">
              <ul class="flex items-center mr-auto mb-0">
                <li class="list-inline-item">
                  <RouterLink :to="'#'"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-modal">
                    <i class="ti ti-eye text-lg leading-none"></i>
                  </RouterLink>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-edit_add-modal">
                    <i class="ti ti-edit-circle text-lg leading-none"></i>
                  </a>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                    ><i class="ti ti-trash text-lg leading-none"></i>
                  </a>
                </li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <div class="flex items-center">
                <div class="grow ltr:ml-3 rtl:mr-3">
                  <h6 class="mb-0">Jean</h6>
                </div>
              </div>
            </td>
            <td>Jeandavid@yahoo.fr</td>
            <td> <span class = "badge text-danger border border-danger bg-danger-500/10 rounded-full text-sm">Manager</span></td>
            <td class="text-center">
              <ul class="flex items-center mr-auto mb-0">
                <li class="list-inline-item">
                  <RouterLink :to="'#'"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-modal">
                    <i class="ti ti-eye text-lg leading-none"></i>
                  </RouterLink>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-edit_add-modal">
                    <i class="ti ti-edit-circle text-lg leading-none"></i>
                  </a>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                    ><i class="ti ti-trash text-lg leading-none"></i>
                  </a>
                </li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <div class="flex items-center">
                <div class="grow ltr:ml-3 rtl:mr-3">
                  <h6 class="mb-0">Yves</h6>
                </div>
              </div>
            </td>
            <td>Yvesgaspard@yahoo.fr</td>
            <td> <span class = "badge text-primary-500 border border-primary bg-primary-500/10 rounded-full text-sm">Employee</span></td>
            <td class="text-center">
              <ul class="flex items-center mr-auto mb-0">
                <li class="list-inline-item">
                  <RouterLink :to="'#'"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-secondary btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-modal">
                    <i class="ti ti-eye text-lg leading-none"></i>
                  </RouterLink>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-success btn-pc-default"
                    data-pc-toggle="modal"
                    data-pc-target="#customer-edit_add-modal">
                    <i class="ti ti-edit-circle text-lg leading-none"></i>
                  </a>
                </li>
                <li class="list-inline-item">
                  <a
                    href="#"
                    class="w-8 h-8 rounded-xl inline-flex items-center justify-center btn-link-danger btn-pc-default"
                    ><i class="ti ti-trash text-lg leading-none"></i>
                  </a>
                </li>
              </ul>
            </td>
          </tr>

        </tbody>
      </table>
    </div>
  </template>