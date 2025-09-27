import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatDialogModule, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { ReportService } from '../../../service/report.service';
import { ActivityDetail } from '../../../entity/report';

export interface GeneralDetailDialogData {
  processId: string;
  fullName: string;
}

@Component({
  selector: 'app-general-detail-dialog',
  standalone: true,
  imports: [CommonModule, MatDialogModule, MatButtonModule, MatIconModule, MatProgressBarModule],
  templateUrl: './general-detail-dialog.component.html',
  styleUrl: './general-detail-dialog.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class GeneralDetailDialogComponent implements OnInit {
  details: ActivityDetail[] = [];
  isLoading = true;
  hasError = false;

  constructor(
    private readonly reportService: ReportService,
    private readonly cdr: ChangeDetectorRef,
    private readonly dialogRef: MatDialogRef<GeneralDetailDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public readonly data: GeneralDetailDialogData
  ) {}

  ngOnInit(): void {
    this.loadDetails();
    this.dialogRef.updateSize('680px');
  }

  private loadDetails(): void {
    this.reportService.getGeneralDetail(this.data.processId).subscribe({
      next: (details) => {
        this.details = details;
        this.isLoading = false;
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
}
