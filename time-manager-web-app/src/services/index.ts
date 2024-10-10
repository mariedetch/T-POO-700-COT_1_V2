import userService from "./users";
import clockService from "./clocks";
import workingtimeService from "./workingtimes";

export const API = {
  users: userService,
  cloks: clockService,
  workingtimes: workingtimeService
};