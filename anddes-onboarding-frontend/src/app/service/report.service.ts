import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import {
  ActivityDetail,
  ElearningDetail,
  ElearningReportRow,
  GeneralReportRow,
  MatrixReportRow,
  PagedReportResponse,
  ReportQuery,
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
      { params: this.buildParams('general', query) }
    );
  }

  getElearningReport(query: ReportQuery): Observable<PagedReportResponse<ElearningReportRow>> {
    return this.httpClient.get<PagedReportResponse<ElearningReportRow>>(
      `${this.baseUrl}/elearning`,
      { params: this.buildParams('elearning', query) }
    );
  }

  getMatrixReport(query: ReportQuery): Observable<PagedReportResponse<MatrixReportRow>> {
    return this.httpClient.get<PagedReportResponse<MatrixReportRow>>(
      `${this.baseUrl}/matrix`,
      { params: this.buildParams('matrix', query) }
    );
  }

  getGeneralDetail(userId: string): Observable<ActivityDetail[]> {
    return this.httpClient.get<ActivityDetail[]>(`${this.baseUrl}/general/${userId}`);
  }

  getElearningDetail(userId: string): Observable<ElearningDetail[]> {
    return this.httpClient.get<ElearningDetail[]>(`${this.baseUrl}/elearning/${userId}`);
  }

  downloadReport(type: ReportType, query: ReportQuery): Observable<Blob> {
    return this.httpClient.get(`${this.baseUrl}/download`, {
      params: this.buildParams(type, query),
      responseType: 'blob',
    });
  }

  private buildParams(type: ReportType, query: ReportQuery): HttpParams {
    let params = new HttpParams()
      .set('type', type)
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
}
