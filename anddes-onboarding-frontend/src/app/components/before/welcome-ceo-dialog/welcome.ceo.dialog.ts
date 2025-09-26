import { CommonModule } from "@angular/common";
import { ChangeDetectorRef, Component, Inject } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { MatButtonModule } from "@angular/material/button";
import { MatDialogTitle, MatDialogContent, MatDialogActions, MatDialogClose, MatDialogRef, MAT_DIALOG_DATA } from "@angular/material/dialog";
import { MatFormFieldModule } from "@angular/material/form-field";
import { MatIconModule } from "@angular/material/icon";
import { MatInputModule } from "@angular/material/input";
import { UtilService } from "../../../service/util.service";
import { FileService } from "../../../service/file.service";
import { MatProgressBarModule } from "@angular/material/progress-bar";
import { CEOPresentation } from "../../../entity/activity";

@Component({
    selector: 'welcome-ceo-dialog',
    templateUrl: 'welcome.ceo.dialog.html',
    styleUrl:'welcome.ceo.dialog.css',
    standalone: true,
    imports: [
      MatFormFieldModule,
      MatInputModule,
      FormsModule,
      MatButtonModule,
      MatDialogTitle,
      MatDialogContent,
      MatDialogActions,
      MatDialogClose,
      CommonModule,
      MatIconModule,
      MatProgressBarModule
    ],
  })
export class WelcomeCEODialog {
    isLoadingResults=false
    acceptedVideo = 'video/mp4'
    acceptedImage = 'image/*'
    _CEOPresentation : CEOPresentation
    constructor(
      public dialogRef: MatDialogRef<WelcomeCEODialog>,
      public utilService : UtilService,
      private fileService : FileService,
      private cdr: ChangeDetectorRef,
      @Inject(MAT_DIALOG_DATA) public data : CEOPresentation
    ) {
      this._CEOPresentation=data
    }
    
    ngOnInit() {
      this.dialogRef.updateSize('551px', '383px');
    }
    save(){
      this.dialogRef.close(this._CEOPresentation)
    }
    onVideoSelected(event){
      this.isLoadingResults = true 
      this.cdr.detectChanges();
      if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
        const file = (event.target as HTMLInputElement).files[0];
        this.fileService.upload(file).subscribe((r:any)=>this._CEOPresentation.urlVideo=r.url);
        (event.target as HTMLInputElement).value=null
        this.isLoadingResults = false
        this.cdr.detectChanges();
      }
    }
    onPosterSelected(event){
      this.isLoadingResults = true 
      this.cdr.detectChanges();
      if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
        const file = (event.target as HTMLInputElement).files[0];
        this.fileService.upload(file).subscribe((r:any)=>this._CEOPresentation.urlPoster=r.url);
        (event.target as HTMLInputElement).value=null
        this.isLoadingResults = false
        this.cdr.detectChanges();
      }
    }    
}