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
import { ActivatedRoute, ParamMap, RouterModule } from '@angular/router';
import { EMPTY, Subject, combineLatest } from 'rxjs';
import { startWith, switchMap, takeUntil, tap } from 'rxjs/operators';
import { ActivityDetail, ReportQuery } from '../../../entity/report';
import { ReportService } from '../../../service/report.service';

type DetailQuery = Partial<Omit<ReportQuery, 'pageIndex' | 'pageSize'>>;

type ActivitySection = {
  key: string;
  title: string;
  description: string;
  icon: string;
  activities: ActivityDetail[];
};

const SECTION_METADATA: Record<string, { title: string; description: string; icon: string }> = {
  BEFORE: {
    title: 'Antes',
    description: 'Actividades previas al inicio del colaborador',
    icon: 'schedule',
  },
  FIRST_DAY: {
    title: 'Mi primer día',
    description: 'Tareas esenciales para el primer día de trabajo',
    icon: 'calendar_month',
  },
  FIRST_WEEK: {
    title: 'Mi primera semana',
    description: 'Seguimiento y acompañamiento durante la primera semana',
    icon: 'view_week',
  },
};

const SECTION_ORDER = ['BEFORE', 'FIRST_DAY', 'FIRST_WEEK'];

@Component({
  selector: 'app-general-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, MatButtonModule, MatIconModule, MatProgressBarModule],
  templateUrl: './general-detail.component.html',
  styleUrl: './general-detail.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class GeneralDetailComponent implements OnInit, OnDestroy {
  sections: ActivitySection[] = [];
  details: ActivityDetail[] = [];
  pendingDetails: ActivityDetail[] = [];
  completedDetails: ActivityDetail[] = [];

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
          this.fullName = queryParams.get('fullName') ?? '';
          this.processId = params.get('processId');
          this.currentQuery = this.buildQueryFromParams(queryParams);

          if (!this.processId) {
            this.isLoading = false;
            this.hasError = true;
            this.details = [];
            this.sections = [];
            this.pendingDetails = [];
            this.completedDetails = [];
            this.cdr.markForCheck();
            return EMPTY;
          }

          return this.reportService.getGeneralDetail(this.processId, this.currentQuery ?? undefined);
        })
      )
      .subscribe({
        next: (details) => {
          this.details = details;
          this.pendingDetails = details.filter((detail) => !detail.completed);
          this.completedDetails = details.filter((detail) => detail.completed);
          this.sections = this.buildSections(details);
          this.isLoading = false;
          this.hasError = false;
          this.cdr.markForCheck();
        },
        error: () => {
          this.details = [];
          this.pendingDetails = [];
          this.completedDetails = [];
          this.sections = [];
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

  trackBySection(_: number, section: ActivitySection): string {
    return section.key;
  }

  trackByActivity(index: number, activity: ActivityDetail): string {
    return activity.id ?? activity.activityName ?? activity.title ?? `activity-${index}`;
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

  private buildSections(details: ActivityDetail[]): ActivitySection[] {
    const groups = new Map<string, ActivityDetail[]>();

    for (const detail of details) {
      const key = (detail.parentCode ?? 'OTHER').toString().toUpperCase();
      if (!groups.has(key)) {
        groups.set(key, []);
      }
      groups.get(key)!.push(detail);
    }

    const sections = Array.from(groups.entries()).map(([key, activities]) => {
      const metadata = SECTION_METADATA[key] ?? {
        title: 'Otras actividades',
        description: 'Actividades adicionales del proceso de onboarding',
        icon: 'task_alt',
      };

      const sortedActivities = [...activities].sort((a, b) => {
        const aCompleted = a.completed ? 1 : 0;
        const bCompleted = b.completed ? 1 : 0;
        if (aCompleted !== bCompleted) {
          return aCompleted - bCompleted;
        }
        const aTitle = (a.title ?? a.activityName ?? '').toString().toLowerCase();
        const bTitle = (b.title ?? b.activityName ?? '').toString().toLowerCase();
        return aTitle.localeCompare(bTitle);
      });

      return {
        key,
        title: metadata.title,
        description: metadata.description,
        icon: metadata.icon,
        activities: sortedActivities,
      } satisfies ActivitySection;
    });

    return sections.sort((a, b) => {
      const indexA = SECTION_ORDER.indexOf(a.key);
      const indexB = SECTION_ORDER.indexOf(b.key);
      const safeIndexA = indexA === -1 ? Number.MAX_SAFE_INTEGER : indexA;
      const safeIndexB = indexB === -1 ? Number.MAX_SAFE_INTEGER : indexB;
      if (safeIndexA !== safeIndexB) {
        return safeIndexA - safeIndexB;
      }
      return a.title.localeCompare(b.title);
    });
  }
}
