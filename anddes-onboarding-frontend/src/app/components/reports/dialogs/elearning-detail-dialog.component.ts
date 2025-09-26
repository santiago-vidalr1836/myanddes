import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { ReportService } from '../../../service/report.service';
import { ElearningDetail } from '../../../entity/report';

export interface ElearningDetailDialogData {
  userId: string;
  fullName: string;
}

@Component({
  selector: 'app-elearning-detail-dialog',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatButtonModule, MatTableModule, MatProgressBarModule, MatIconModule],
  templateUrl: './elearning-detail-dialog.component.html',
  styleUrl: './elearning-detail-dialog.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class ElearningDetailDialogComponent implements OnInit {
  readonly displayedColumns = ['courseName', 'minimumScore', 'score', 'attempts', 'status'];
  readonly dataSource = new MatTableDataSource<ElearningDetail>([]);
  isLoading = true;
  hasError = false;

  constructor(
    private readonly reportService: ReportService,
    private readonly cdr: ChangeDetectorRef,
    private readonly dialogRef: MatDialogRef<ElearningDetailDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public readonly data: ElearningDetailDialogData
  ) {}

  ngOnInit(): void {
    this.loadDetails();
    this.dialogRef.updateSize('760px');
  }

  statusClass(detail: ElearningDetail): string {
    const status = detail.status?.toLowerCase() ?? '';
    if (status.includes('complet')) {
      return 'status-chip completed';
    }
    if (status.includes('pend')) {
      return 'status-chip pending';
    }
    return 'status-chip in-progress';
  }

  private loadDetails(): void {
    this.reportService.getElearningDetail(this.data.userId).subscribe({
      next: (details) => {
        this.dataSource.data = details;
        this.isLoading = false;
        this.cdr.markForCheck();
      },
      error: () => {
        this.dataSource.data = [];
        this.isLoading = false;
        this.hasError = true;
        this.cdr.markForCheck();
      },
    });
  }
}
