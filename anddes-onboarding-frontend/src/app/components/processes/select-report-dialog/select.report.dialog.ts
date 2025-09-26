import { Component, Inject, OnInit } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MatButtonModule } from "@angular/material/button";
import { MAT_DIALOG_DATA, MatDialogClose, MatDialogModule, MatDialogRef } from "@angular/material/dialog";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatIconModule } from "@angular/material/icon";
import { MatInputModule } from "@angular/material/input";

@Component({
    selector: 'select-report-dialog',
    templateUrl: 'select.report.dialog.html',
    styleUrl:'select.report.dialog.scss',
    standalone: true,
    imports: [
      MatDialogModule,
      MatDialogClose,
      MatButtonModule,
      MatIconModule
    ],
  })
export class SelectReportDialog implements OnInit{
    result : string
    constructor(public dialogRef: MatDialogRef<SelectReportDialog>,
                @Inject(MAT_DIALOG_DATA) public data : string){
        this.result=this.data?this.data:''
    }
    ngOnInit() {
      this.dialogRef.updateSize('763px', '513px');
    }
    save(){
      this.dialogRef.close(this.result)
    }
}