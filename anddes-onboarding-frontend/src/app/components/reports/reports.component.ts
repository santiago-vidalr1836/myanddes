import { AfterViewInit, ChangeDetectionStrategy, ChangeDetectorRef, Component, ViewChild } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormControl, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatSelectModule } from '@angular/material/select';
import { MatInputModule } from '@angular/material/input';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatPaginator, MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatDialog } from '@angular/material/dialog';
import { Subject, startWith, switchMap, tap, throwError } from 'rxjs';
import { catchError, debounceTime, distinctUntilChanged, map } from 'rxjs/operators';
import {
  ElearningReportRow,
  GeneralReportRow,
  MatrixReportRow,
  ReportQuery,
  ReportRowState,
  ReportStateFilter,
  ReportType,
} from '../../entity/report';
import { ReportService } from '../../service/report.service';
import { DateRangeDialogComponent, DateRangeSelection } from './dialogs/date-range-dialog.component';
import { GeneralDetailDialogComponent } from './dialogs/general-detail-dialog.component';
import { ElearningDetailDialogComponent } from './dialogs/elearning-detail-dialog.component';

type ReportPeriod = '3m' | '1m' | 'custom';

@Component({
  selector: 'app-reports',
  standalone: true,
  imports: [
    CommonModule,
    ReactiveFormsModule,
    MatFormFieldModule,
    MatSelectModule,
    MatInputModule,
    MatIconModule,
    MatButtonModule,
    MatTableModule,
    MatSortModule,
    MatPaginatorModule,
    MatProgressBarModule,
  ],
  templateUrl: './reports.component.html',
  styleUrl: './reports.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ReportsComponent implements AfterViewInit {
  readonly typeControl = new FormControl<ReportType>('general', { nonNullable: true });
  readonly periodControl = new FormControl<ReportPeriod>('3m', { nonNullable: true });
  readonly stateControl = new FormControl<ReportStateFilter>('all', { nonNullable: true });
  readonly searchControl = new FormControl<string>('', { nonNullable: true });

  readonly reportTypes = [
    { value: 'general' as ReportType, label: 'General' },
    { value: 'elearning' as ReportType, label: 'Inducci\u00f3n e-learning' },
    { value: 'matrix' as ReportType, label: 'Matriz' },
  ];

  readonly periodOptions = [
    { value: '3m' as ReportPeriod, label: '3 meses' },
    { value: '1m' as ReportPeriod, label: '\u00daltimo mes' },
    { value: 'custom' as ReportPeriod, label: 'Rango de fechas' },
  ];

  readonly stateOptions = [
    { value: 'all' as ReportStateFilter, label: 'Todos' },
    { value: 'pending' as ReportStateFilter, label: 'Pendientes' },
    { value: 'completed' as ReportStateFilter, label: 'Completados' },
  ];

  readonly dataSource = new MatTableDataSource<any>([]);
  displayedColumns: string[] = [];
  resultsLength = 0;
  isLoading = false;

  private readonly load$ = new Subject<void>();
  private customRange?: DateRangeSelection;
  private lastPeriod: ReportPeriod = '3m';
  private currentType: ReportType = this.typeControl.value;

  @ViewChild(MatSort) sort!: MatSort;
  @ViewChild(MatPaginator) paginator!: MatPaginator;

  constructor(
    private readonly reportService: ReportService,
    private readonly dialog: MatDialog,
    private readonly cdr: ChangeDetectorRef
  ) {
    this.updateDisplayedColumns(this.currentType);
  }

  ngAfterViewInit(): void {
    this.sort.sortChange.subscribe(() => {
      this.resetPaginator();
      this.load$.next();
    });

    this.paginator.page.subscribe(() => this.load$.next());

    this.typeControl.valueChanges.subscribe((type) => {
      this.currentType = type;
      this.updateDisplayedColumns(type);
      this.resetPaginator();
      this.load$.next();
    });

    this.stateControl.valueChanges.subscribe(() => {
      this.resetPaginator();
      this.load$.next();
    });

    this.periodControl.valueChanges.subscribe((period) => {
      if (period === 'custom') {
        this.openDateRangeDialog();
      } else {
        this.customRange = undefined;
        this.lastPeriod = period;
        this.resetPaginator();
        this.load$.next();
      }
    });

    this.searchControl.valueChanges
      .pipe(debounceTime(400), distinctUntilChanged())
      .subscribe(() => {
        this.resetPaginator();
        this.load$.next();
      });

    this.load$
      .pipe(
        startWith(void 0),
        tap(() => {
          this.isLoading = true;
          this.cdr.markForCheck();
        }),
        switchMap(() =>
          this.loadReportData().pipe(
            catchError((error) => {
              this.isLoading = false;
              this.cdr.markForCheck();
              return throwError(() => error);
            })
          )
        )
      )
      .subscribe({
        next: () => {
          this.isLoading = false;
          this.cdr.markForCheck();
        },
        error: () => {
          this.isLoading = false;
          this.cdr.markForCheck();
        },
      });
  }

  get isGeneral(): boolean {
    return this.currentType === 'general';
  }

  get isElearning(): boolean {
    return this.currentType === 'elearning';
  }

  get isMatrix(): boolean {
    return this.currentType === 'matrix';
  }

  clearSearch(): void {
    this.searchControl.setValue('');
  }

  downloadExcel(): void {
    const query = this.buildQuery();
    this.reportService.downloadReport(this.currentType, query).subscribe((blob) => {
      const url = URL.createObjectURL(blob);
      const anchor = document.createElement('a');
      anchor.href = url;
      anchor.download = `reporte-${this.currentType}.xlsx`;
      anchor.click();
      URL.revokeObjectURL(url);
    });
  }

  openGeneralDetail(row: any): void {
    const generalRow = row as GeneralReportRow;
    this.dialog.open(GeneralDetailDialogComponent, {
      data: { userId: generalRow.id, fullName: generalRow.fullName },
    });
  }

  openElearningDetail(row: any): void {
    const elearningRow = row as ElearningReportRow;
    this.dialog.open(ElearningDetailDialogComponent, {
      data: { userId: elearningRow.id, fullName: elearningRow.fullName },
    });
  }

  getProgressLabel(row: any): string {
    const general = row as GeneralReportRow;
    return `${general.completedActivities}/${general.totalActivities}`;
  }

  stateLabel(state: ReportRowState): string {
    switch (state) {
      case 'completed':
        return 'Completado';
      case 'pending':
        return 'Pendiente';
      case 'in_progress':
        return 'En progreso';
      default:
        return state;
    }
  }

  stateClass(state: ReportRowState): string {
    switch (state) {
      case 'completed':
        return 'status-pill status-completed';
      case 'pending':
        return 'status-pill status-pending';
      case 'in_progress':
      default:
        return 'status-pill status-progress';
    }
  }

  resolveState(row: any): ReportRowState {
    const value = (row as GeneralReportRow).state ?? (row as ElearningReportRow).state;
    return (value ?? 'pending') as ReportRowState;
  }

  private loadReportData() {
    const query = this.buildQuery();
    switch (this.currentType) {
      case 'general':
        return this.reportService.getGeneralReport(query).pipe(
          tap((response) => {
            this.resultsLength = response.total;
            this.dataSource.data = response.data;
            this.cdr.markForCheck();
          }),
          map(() => void 0)
        );
      case 'elearning':
        return this.reportService.getElearningReport(query).pipe(
          tap((response) => {
            this.resultsLength = response.total;
            this.dataSource.data = response.data;
            this.cdr.markForCheck();
          }),
          map(() => void 0)
        );
      case 'matrix':
      default:
        return this.reportService.getMatrixReport(query).pipe(
          tap((response) => {
            this.resultsLength = response.total;
            this.dataSource.data = response.data;
            this.cdr.markForCheck();
          }),
          map(() => void 0)
        );
    }
  }

  private buildQuery(): ReportQuery {
    const { startDate, endDate } = this.resolveDates();
    const direction = this.sort?.direction ? (this.sort.direction as 'asc' | 'desc') : undefined;

    return {
      state: this.stateControl.value,
      search: this.searchControl.value?.trim() || undefined,
      startDate,
      endDate,
      orderBy: this.sort?.active,
      direction,
      pageIndex: this.paginator?.pageIndex ?? 0,
      pageSize: this.paginator?.pageSize ?? 10,
    };
  }

  private resolveDates(): { startDate?: string; endDate?: string } {
    const now = new Date();
    const end = now.toISOString();

    if (this.periodControl.value === '1m') {
      const start = new Date();
      start.setMonth(start.getMonth() - 1);
      return { startDate: start.toISOString(), endDate: end };
    }

    if (this.periodControl.value === '3m') {
      const start = new Date();
      start.setMonth(start.getMonth() - 3);
      return { startDate: start.toISOString(), endDate: end };
    }

    if (this.customRange?.start && this.customRange?.end) {
      return {
        startDate: this.customRange.start.toISOString(),
        endDate: this.customRange.end.toISOString(),
      };
    }

    return {};
  }

  private resetPaginator(): void {
    if (this.paginator) {
      this.paginator.firstPage();
    }
  }

  private updateDisplayedColumns(type: ReportType): void {
    if (type === 'general') {
      this.displayedColumns = ['fullName', 'position', 'bossName', 'progress', 'state', 'startDate', 'actions'];
    } else if (type === 'elearning') {
      this.displayedColumns = ['fullName', 'totalCourses', 'approvedCourses', 'averageScore', 'state', 'updatedAt', 'actions'];
    } else {
      this.displayedColumns = ['fullName', 'area', 'position', 'matrixStatus', 'updatedAt'];
    }
  }

  private openDateRangeDialog(): void {
    const dialogRef = this.dialog.open<DateRangeDialogComponent, DateRangeSelection | undefined, DateRangeSelection>(
      DateRangeDialogComponent,
      {
        data: this.customRange,
      }
    );

    dialogRef.afterClosed().subscribe((range) => {
      if (range) {
        this.customRange = range;
        this.lastPeriod = 'custom';
        this.resetPaginator();
        this.load$.next();
      } else {
        this.periodControl.setValue(this.lastPeriod, { emitEvent: false });
      }
    });
  }
}
