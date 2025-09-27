import { CommonModule, Location } from '@angular/common';
import {
  ChangeDetectionStrategy,
  ChangeDetectorRef,
  Component,
  OnDestroy,
  OnInit,
} from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatTableModule } from '@angular/material/table';
import { ActivatedRoute, ParamMap } from '@angular/router';
import { EMPTY, Subject, combineLatest } from 'rxjs';
import { startWith, switchMap, takeUntil, tap } from 'rxjs/operators';
import { ElearningDetail, ReportQuery } from '../../../entity/report';
import { ReportService } from '../../../service/report.service';

export type DetailQuery = Partial<Omit<ReportQuery, 'pageIndex' | 'pageSize'>>;

@Component({
  selector: 'app-elearning-detail',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatIconModule, MatProgressBarModule, MatTableModule],
  templateUrl: './elearning-detail.component.html',
  styleUrl: './elearning-detail.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ElearningDetailComponent implements OnInit, OnDestroy {
  readonly displayedColumns = ['courseName', 'result', 'attempts', 'state'];

  details: ElearningDetail[] = [];
  isLoading = true;
  hasError = false;
  fullName = '';

  private processId: string | null = null;
  private currentQuery: DetailQuery | undefined;
  private readonly destroy$ = new Subject<void>();
  private readonly reload$ = new Subject<void>();

  constructor(
    private readonly activatedRoute: ActivatedRoute,
    private readonly reportService: ReportService,
    private readonly cdr: ChangeDetectorRef,
    private readonly location: Location
  ) {}

  ngOnInit(): void {
    combineLatest([
      this.activatedRoute.paramMap,
      this.activatedRoute.queryParamMap,
      this.reload$.pipe(startWith(void 0)),
    ])
      .pipe(
        takeUntil(this.destroy$),
        tap(() => {
          this.isLoading = true;
          this.hasError = false;
          this.cdr.markForCheck();
        }),
        switchMap(([params, queryParams]) => {
          this.processId = params.get('processId');
          this.fullName = queryParams.get('fullName') ?? '';
          this.currentQuery = this.buildQueryFromParams(queryParams);

          if (!this.processId) {
            this.isLoading = false;
            this.hasError = true;
            this.details = [];
            this.cdr.markForCheck();
            return EMPTY;
          }

          return this.reportService.getElearningDetail(this.processId, this.currentQuery);
        })
      )
      .subscribe({
        next: (details) => {
          this.details = details;
          this.isLoading = false;
          this.hasError = false;
          this.cdr.markForCheck();
        },
        error: () => {
          this.details = [];
          this.isLoading = false;
          this.hasError = true;
          this.cdr.markForCheck();
        },
      });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  goBack(): void {
    this.location.back();
  }

  reload(): void {
    this.reload$.next();
  }

  trackByContent(index: number, detail: ElearningDetail): string {
    return detail.contentId ?? detail.courseName ?? `course-${index}`;
  }

  resultLabel(detail: ElearningDetail): string {
    return detail.result != null ? `${detail.result}` : '—';
  }

  statusLabel(detail: ElearningDetail): string {
    if (detail.result != null) {
      return detail.result >= detail.minimumScore ? 'Aprobado' : 'Desaprobado';
    }

    return 'Desaprobado';
  }

  private buildQueryFromParams(queryParams: ParamMap): DetailQuery | undefined {
    const query: DetailQuery = {};

    const state = queryParams.get('state');
    if (state && state !== 'all') {
      query.state = state as DetailQuery['state'];
    }

    const search = queryParams.get('search');
    if (search) {
      query.search = search;
    }

    const startDate = queryParams.get('startDate');
    if (startDate) {
      query.startDate = startDate;
    }

    const endDate = queryParams.get('endDate');
    if (endDate) {
      query.endDate = endDate;
    }

    const orderBy = queryParams.get('orderBy');
    if (orderBy) {
      query.orderBy = orderBy;
    }

    const direction = queryParams.get('direction');
    if (direction === 'asc' || direction === 'desc') {
      query.direction = direction;
    }

    return Object.keys(query).length > 0 ? query : undefined;
  }
}
