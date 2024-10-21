<template>
    <div class="table-responsive">
      <table class="table table-hover" id="pc-dt-simple">
        <thead>
          <tr>
            <th>Team Code</th>
            <th>Team Name</th>
            <th>Total members</th>
            <th class="text-center">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>
              <div class="flex items-center">
                <div class="grow ltr:ml-3 rtl:mr-3">
                  <h6 class="mb-0">1</h6>
                </div>
              </div>
            </td>
            <td>Gardiens du jour</td>
            <td> <span class = "badge bg-success-500/10 border border-success text-success-500 rounded-full text-sm">7 members</span></td>
            <td class="text-center">
              <ul class="flex items-center mr-auto mb-0">
                <li class="list-inline-item">
                  <RouterLink :to="`/team_members`"
                    class="px-4 py-2 bg-gray-200 rounded-lg inline-flex items-center justify-center btn-link-secondary btn-pc-default"
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
                    ><i class="ti ti-trash text-lg leading-none"></i
                  ></a>
                </li>
              </ul>
            </td>
          </tr>
          <tr>
            <td>
              <div class="flex items-center">
                <div class="grow ltr:ml-3 rtl:mr-3">
                  <h6 class="mb-0">2</h6>
                </div>
              </div>
            </td>
            <td>Protecteur de la nuit</td>
            <td> <span class = "badge bg-success-500/10 text-success-500 border border-success rounded-full text-sm">12 members</span></td>
            <td class="text-center">
              <ul class="flex items-center mr-auto mb-0">
                <li class="list-inline-item">
                  <RouterLink :to="`/team_members`"
                    class="px-4 py-2 bg-gray-200 rounded-lg inline-flex items-center justify-center btn-link-secondary btn-pc-default"
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
                    ><i class="ti ti-trash text-lg leading-none"></i
                  ></a>
                </li>
              </ul>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </template>