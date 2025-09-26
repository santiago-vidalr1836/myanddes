import { Component, Inject, inject } from '@angular/core';
import { MAT_BOTTOM_SHEET_DATA, MatBottomSheetRef } from '@angular/material/bottom-sheet';
import { CEOPresentation } from '../../entity/ceopresentation';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';

@Component({
  selector: 'app-welcome-ceo-video',
  imports: [MatButtonModule,MatIconModule],
  templateUrl: './welcome-ceo-video.component.html',
  styleUrl: './welcome-ceo-video.component.scss'
})
export class WelcomeCeoVideoComponent {
  private _bottomSheetRef = inject<MatBottomSheetRef<WelcomeCeoVideoComponent>>(MatBottomSheetRef);
  disabled = true;
  ceoPresentation = {} as CEOPresentation;
  constructor(@Inject(MAT_BOTTOM_SHEET_DATA) public data: CEOPresentation){
    this.ceoPresentation=data;
  }
  closeSheet(){
    this._bottomSheetRef.dismiss(!this.disabled);
  }
  onVideoEnded(){
    this.disabled=false;
  }
}
