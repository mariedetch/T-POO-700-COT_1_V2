export interface ApiResponse<T> {
  data: T;
}

export interface PaginationResponse<T> {
  items: T[],
  page: number,
  per_page: number,
  total_count: number
}
