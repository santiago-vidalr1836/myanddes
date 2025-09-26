import { ChangeDetectionStrategy, Component, Inject } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
import { MatDialogModule, MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatInputModule } from '@angular/material/input';
import { provideNativeDateAdapter } from '@angular/material/core';

export interface DateRangeSelection {
  start: Date;
  end: Date;
}

@Component({
  selector: 'app-date-range-dialog',
  standalone: true,
  imports: [
    MatDialogModule,
    ReactiveFormsModule,
    MatButtonModule,
    MatFormFieldModule,
    MatDatepickerModule,
    MatInputModule,
  ],
  templateUrl: './date-range-dialog.component.html',
  styleUrl: './date-range-dialog.component.scss',
  changeDetection: ChangeDetectionStrategy.OnPush,
  providers: [provideNativeDateAdapter()],
})
export class DateRangeDialogComponent {
  readonly range = new FormGroup({
    start: new FormControl<Date | null>(this.data?.start ?? null),
    end: new FormControl<Date | null>(this.data?.end ?? null),
  });

  constructor(
    private readonly dialogRef: MatDialogRef<DateRangeDialogComponent, DateRangeSelection | undefined>,
    @Inject(MAT_DIALOG_DATA) public readonly data: DateRangeSelection | undefined
  ) {}

  cancel(): void {
    this.dialogRef.close();
  }

  apply(): void {
    const start = this.range.value.start;
    const end = this.range.value.end;

    if (!start || !end) {
      return;
    }

    this.dialogRef.close({ start, end });
  }
}
