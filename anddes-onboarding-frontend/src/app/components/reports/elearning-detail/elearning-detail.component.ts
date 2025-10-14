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
import { ActivatedRoute } from '@angular/router';
import { EMPTY, Subject, combineLatest } from 'rxjs';
import { startWith, switchMap, takeUntil, tap } from 'rxjs/operators';
import { ElearningDetail } from '../../../entity/report';
import { ReportService } from '../../../service/report.service';

@Component({
  selector: 'app-elearning-detail',
  standalone: true,
  imports: [CommonModule, MatButtonModule, MatIconModule, MatProgressBarModule, MatTableModule],
  templateUrl: './elearning-detail.component.html',
  styleUrl: './elearning-detail.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ElearningDetailComponent implements OnInit, OnDestroy {
  readonly displayedColumns = ['courseName', 'result','minimumScore', 'attempts', 'state'];

  details: ElearningDetail[] = [];
  isLoading = true;
  hasError = false;
  fullName = '';

  private processId: string | null = null;
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

          if (!this.processId) {
            this.isLoading = false;
            this.hasError = true;
            this.details = [];
            this.cdr.markForCheck();
            return EMPTY;
          }

          return this.reportService.getElearningDetail(this.processId);
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
}
