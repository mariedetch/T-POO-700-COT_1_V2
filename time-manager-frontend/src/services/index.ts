import authService from "./auth";
import userService from "./users";
import clockService from "./clocks";
import workingtimeService from "./workingtimes";

export const API = {
  auth: authService,
  users: userService,
  clocks: clockService,
  workingtimes: workingtimeService
};