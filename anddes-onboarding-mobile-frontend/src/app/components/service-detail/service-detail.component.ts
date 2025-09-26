import {ChangeDetectionStrategy, Component, Inject, inject, viewChild} from '@angular/core';
import {MatButtonModule} from '@angular/material/button';
import {MatAccordion, MatExpansionModule} from '@angular/material/expansion';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatIconModule} from '@angular/material/icon';
import {MatInputModule} from '@angular/material/input';
import { Service } from '../../entity/service';
import { SafeHtmlPipe } from "../../pipe/safe-html.pipe";
import { MAT_BOTTOM_SHEET_DATA,MatBottomSheetRef } from '@angular/material/bottom-sheet';

@Component({
  selector: 'app-service-detail',
  imports: [MatButtonModule,
    MatExpansionModule,
    MatIconModule,
    MatFormFieldModule,
    MatInputModule, 
    SafeHtmlPipe],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './service-detail.component.html',
  styleUrl: './service-detail.component.scss'
})
export class ServiceDetailComponent {
  accordion = viewChild.required(MatAccordion);
  private _bottomSheetRef = inject<MatBottomSheetRef<ServiceDetailComponent>>(MatBottomSheetRef);

  service = {} as Service;
  constructor(@Inject(MAT_BOTTOM_SHEET_DATA) public data: Service){
    this.data.details.forEach(d=>d.description=d.description.replaceAll("<img","<img width=\'100%\'"))
    this.service=data;
  }
}
