export interface Clock {
  id: string,
  time: Date,
  status: Boolean
}

export interface ClockList {
  day: string,
  clocks: Clock[]
}