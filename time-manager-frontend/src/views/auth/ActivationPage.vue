

<script #activeStep>
import "form-wizard-vue3/dist/form-wizard-vue3.css";
import Wizard from "form-wizard-vue3";

export default {
  name: "App",
  components: {
    Wizard,
  },
  data() {
    return {
      currentTabIndex: 0,
      options: ["Option 1", "Option 2", "Option 3"],
      selectedOption: "",
    };
  },
  methods: {
    onChangeCurrentTab(index, oldIndex) {
      console.log(index, oldIndex);
      this.currentTabIndex = index;
    },
    onTabBeforeChange() {
      if (this.currentTabIndex === 0) {
        console.log("First Tab");
      }
      console.log("All Tabs");
    },
    wizardCompleted() {
      console.log("Wizard Completed");
    },
  },
};
</script>

<template>
  <form>
    <div class="mb-4">
      <h3 class="mb-2">
        <b>Create Password</b>
      </h3>
      <p class="text-muted">Please choose your new password</p>
    </div>
    <div class="mb-3">
      <Wizard squared-tabs navigable-tabs scrollable-tabs :nextButton="{
        text: 'Next',
        icon: 'check',
        hideIcon: true, // default false but selected for sample
        hideText: false, // default false but selected for sample
      }" :custom-tabs="[
        {
          title: 'Your informations',
        },
        {
          title: 'Your Password',
        },
      ]" :beforeChange="onTabBeforeChange" @change="onChangeCurrentTab" @complete:wizard="wizardCompleted">
        <template v-if="currentTabIndex === 0">
          <div class="mb-3">
            <label class="form-label">First name</label>
            <input type="text" class="form-control" placeholder="First Name">
          </div>
          <div class="mb-3">
            <label class="form-label">Last Name</label>
            <input type="text" class="form-control" placeholder="Last Name">
          </div>
          <div class="mb-3">
            <label class="form-label">Phone number</label>
            <input type="number" class="form-control" placeholder="Phone number">
          </div>
          <v-select :items="options" label="Select an option" v-model="selectedOption"></v-select>
        </template>
        <template v-if="currentTabIndex === 1">
          <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" class="form-control" placeholder="Password">
          </div>
          <div class="mb-4">
            <label class="form-label">Confirm Password</label>
            <input type="password" class="form-control" placeholder="Confirm Password">
          </div>
          <v-select :items="options" label="Select an option" v-model="selectedOption"></v-select>
        </template>
      </Wizard>
    </div>
  </form>
</template>

