import { Component, Inject, OnInit } from "@angular/core";
import { FormsModule, ReactiveFormsModule } from "@angular/forms";
import { MatButtonModule } from "@angular/material/button";
import { MAT_DIALOG_DATA, MatDialogModule, MatDialogRef } from "@angular/material/dialog";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatInputModule } from "@angular/material/input";

@Component({
    selector: 'option-edit-dialog',
    templateUrl: 'option.edit.dialog.html',
    styleUrl:'option.edit.dialog.scss',
    standalone: true,
    imports: [
      MatFormFieldModule,
      MatInputModule,
      FormsModule,
      ReactiveFormsModule,
      MatDialogModule,
      MatButtonModule
    ],
  })
export class OptionEditDialog implements OnInit{
    result : string
    constructor(public dialogRef: MatDialogRef<OptionEditDialog>,
                @Inject(MAT_DIALOG_DATA) public data : string){
        this.result=this.data?this.data:''
    }
    ngOnInit() {
      this.dialogRef.updateSize('451px', '220px');
    }
    save(){
      this.dialogRef.close(this.result)
    }
}