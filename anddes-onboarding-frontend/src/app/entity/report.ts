export type ReportType = 'general' | 'elearning' | 'matrix';

export type ReportStateFilter = 'all' | 'pending' | 'completed';

export interface ReportQuery {
  state: ReportStateFilter;
  search?: string;
  startDate?: string;
  endDate?: string;
  orderBy?: string;
  direction?: 'asc' | 'desc';
  pageIndex: number;
  pageSize: number;
}

export interface PagedReportResponse<T> {
  total: number;
  data: T[];
}

export type ReportRowState = 'pending' | 'in_progress' | 'completed';

export interface GeneralReportRow {
  processId: string;
  dni: string;
  fullName: string;
  startDate: string;
  finishDate: string;
  completedActivities: number;
  totalActivities: number;
  progress: number;
  delayed: boolean;
}

export interface ElearningReportRow {
  id: string;
  fullName: string;
  totalCourses: number;
  approvedCourses: number;
  averageScore: number;
  state: ReportRowState;
  updatedAt: string;
}

export interface MatrixReportRow {
  id: string;
  fullName: string;
  area: string;
  position: string;
  matrixStatus: string;
  updatedAt: string;
}

export interface ActivityDetail {
  id?: string;
  title?: string;
  responsible?: string;
  completed: boolean;
  completedAt?: string;
  state?: string;
  period?: string;
  activityName?: string;
  completionDate?: string;
  parentCode?: string;
}

export interface ElearningDetail {
  id: string;
  courseName: string;
  minimumScore: number;
  score: number;
  attempts: number;
  status: string;
}
