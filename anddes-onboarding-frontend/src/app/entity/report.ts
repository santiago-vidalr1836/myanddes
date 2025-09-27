export type ReportType = 'general' | 'elearning' | 'matrix';

export type ReportStateFilter = 'all' | 'Pendiente' | 'Completado';

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

export type ReportRowState = 'Pendiente' | 'Completado' | 'Aprobado' | 'Desaprobado';

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
  processId: string;
  dni: string;
  fullName: string;
  startDate?: string;
  finishDate?: string;
  progress: number;
  state: ReportRowState;
}

export interface MatrixReportRow {
  processId: string;
  dni: string;
  fullName: string;
  startDate?: string;
  elearningFinishDate?: string;
  generalCompleted: number;
  generalTotal: number;
  elearningCompleted: number;
  elearningTotal: number;
  processState: string;
  results: Record<string, string>;
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
  contentId: string;
  courseName: string;
  result?: number;
  minimumScore: number;
  attempts: number;
  progress: number;
  readCards: number;
  correctAnswers: number;
  state: ReportRowState;
}
