import { Component, Inject } from '@angular/core';
import { FirstDayInformationItem } from '../../entity/first-day-information-item';
import { SafeHtmlPipe } from "../../pipe/safe-html.pipe";
import { MAT_BOTTOM_SHEET_DATA,MatBottomSheetRef } from '@angular/material/bottom-sheet';

@Component({
  selector: 'app-first-day-information-detail',
  imports: [SafeHtmlPipe],
  templateUrl: './first-day-information-detail.component.html',
  styleUrl: './first-day-information-detail.component.scss'
})
export class FirstDayInformationDetailComponent {
  item ={} as FirstDayInformationItem;
  constructor(@Inject(MAT_BOTTOM_SHEET_DATA) public data:FirstDayInformationItem){
    if(data.body)
      data.body=data.body.replaceAll("<img","<img width=\'100%\'");
    this.item = data;
  }
}
