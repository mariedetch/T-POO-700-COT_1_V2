export interface Workingtime {
    id: string,
    start: string | Date,
    end: string | Date,
    user_id: String
  }
  
  export interface WorkingtimeRequest {
    workingtime: {
        start: string | Date,
        end: string | Date,
    }
  }