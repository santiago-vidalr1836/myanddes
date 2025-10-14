import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from '../../environments/environment';
import {
  ActivityDetail,
  ElearningDetail,
  ElearningReportRow,
  GeneralReportRow,
  MatrixReportRow,
  PagedReportResponse,
  ReportQuery,
  ReportRowState,
  ReportType,
} from '../entity/report';

@Injectable({
  providedIn: 'root',
})
export class ReportService {
  private readonly baseUrl = `${environment.baseUrl}reports`;

  constructor(private readonly httpClient: HttpClient) {}

  getGeneralReport(query: ReportQuery): Observable<PagedReportResponse<GeneralReportRow>> {
    return this.httpClient.get<PagedReportResponse<GeneralReportRow>>(
      `${this.baseUrl}/general`,
      { params: this.buildParams(query) }
    );
  }

  getElearningReport(query: ReportQuery): Observable<PagedReportResponse<ElearningReportRow>> {
    return this.httpClient
      .get<PagedReportResponse<ElearningReportRow>>(`${this.baseUrl}/elearning`, {
        params: this.buildParams(query),
      })
      .pipe(
        map((response) => ({
          total: response.total,
          data: response.data.map((row) => ({
            processId: row.processId != null ? String(row.processId) : '',
            dni: row.dni ?? '',
            fullName: row.fullName ?? '',
            startDate: row.startDate,
            finishDate: row.finishDate,
            progress: row.progress ?? 0,
            state: (row.state ?? 'Pendiente') as ReportRowState,
            delayed: row.delayed
          })),
        }))
      );
  }

  getMatrixReport(query: ReportQuery): Observable<PagedReportResponse<MatrixReportRow>> {
    return this.httpClient
      .get<PagedReportResponse<any>>(`${this.baseUrl}/matrix`, {
        params: this.buildParams(query),
      })
      .pipe(
        map((response) => ({
          total: response.total ?? 0,
          data: (response.data ?? []).map((row: any) => ({
            processId: row.processId != null ? String(row.processId) : '',
            dni: row.dni ?? '',
            fullName: row.fullName ?? '',
            startDate: row.startDate != null ? String(row.startDate) : undefined,
            finishDate: row.finishDate != null ? String(row.finishDate) : undefined,
            generalProgress: Number(row.generalProgress ?? 0),
            processState: row.processState ?? '',
            elearningProgress: Number(row.elearningProgress ?? 0),
            results: this.normalizeElearningResults(row.elearningResults),
          })),
        }))
      );
  }

  private normalizeElearningResults(
    results: Record<string, unknown> | null | undefined
  ): Record<string, number | null> {
    if (!results) {
      return {};
    }

    return Object.entries(results).reduce<Record<string, number | null>>((acc, [key, value]) => {
      if (value == null || value === '') {
        acc[key] = null;
      } else if (typeof value === 'number') {
        acc[key] = value;
      } else {
        const parsed = Number(value);
        acc[key] = Number.isNaN(parsed) ? null : parsed;
      }
      return acc;
    }, {});
  }

  getGeneralDetail(
    processId: string,
    query?: Partial<Omit<ReportQuery, 'pageIndex' | 'pageSize'>>
  ): Observable<ActivityDetail[]> {
    const params = query ? this.buildDetailParams(query) : undefined;

    return this.httpClient.get<ActivityDetail[]>(`${this.baseUrl}/general/${processId}/activities`, {
      params,
    });
  }

  getElearningDetail(processId: string): Observable<ElearningDetail[]> {
    return this.httpClient
      .get<ElearningDetail[]>(`${this.baseUrl}/elearning/${processId}/courses`)
      .pipe(
        map((details) =>
          details.map((detail) => ({
            contentId: detail.contentId != null ? String(detail.contentId) : '',
            courseName: detail.courseName ?? '',
            result: detail.result ?? undefined,
            minimumScore: detail.minimumScore ?? 0,
            attempts: detail.attempts ?? 0,
            progress: detail.progress ?? 0,
            readCards: detail.readCards ?? 0,
            correctAnswers: detail.correctAnswers ?? 0,
            state: detail.state,
          }))
        )
      );
  }

  downloadReport(type: ReportType, query: ReportQuery): Observable<Blob> {
    return this.httpClient.get(`${this.baseUrl}/${type}/download`, {
      params: this.buildParams(query),
      responseType: 'blob',
    });
  }

  private buildParams(query: ReportQuery): HttpParams {
    let params = new HttpParams()
      .set('state', query.state)
      .set('page', query.pageIndex)
      .set('pageSize', query.pageSize);

    if (query.search) {
      params = params.set('search', query.search);
    }
    if (query.startDate) {
      params = params.set('startDate', query.startDate);
    }
    if (query.endDate) {
      params = params.set('endDate', query.endDate);
    }
    if (query.orderBy) {
      params = params.set('orderBy', query.orderBy);
    }
    if (query.direction) {
      params = params.set('direction', query.direction);
    }

    return params;
  }

  private buildDetailParams(query: Partial<Omit<ReportQuery, 'pageIndex' | 'pageSize'>>): HttpParams {
    let params = new HttpParams();

    if (query.state) {
      params = params.set('state', query.state);
    }

    if (query.search) {
      params = params.set('search', query.search);
    }

    if (query.startDate) {
      params = params.set('startDate', query.startDate);
    }

    if (query.endDate) {
      params = params.set('endDate', query.endDate);
    }

    if (query.orderBy) {
      params = params.set('orderBy', query.orderBy);
    }

    if (query.direction) {
      params = params.set('direction', query.direction);
    }

    return params;
  }
}
