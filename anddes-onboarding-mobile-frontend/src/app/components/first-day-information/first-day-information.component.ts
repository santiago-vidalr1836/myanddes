import { Component, inject } from '@angular/core';
import { FirstDayInformationItem } from '../../entity/first-day-information-item';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { MatBottomSheet, MatBottomSheetModule } from '@angular/material/bottom-sheet';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { FirstDayInformationDetailComponent } from '../first-day-information-detail/first-day-information-detail.component';
import { ProcessActivity } from '../../entity/process-activity';
import { ServiceDetailComponent } from '../service-detail/service-detail.component';
import { ServiceService } from '../../service/service.service';

@Component({
  selector: 'app-first-day-information',
  imports: [MatCardModule, MatButtonModule, MatProgressBarModule, MatIconModule,MatBottomSheetModule],
  templateUrl: './first-day-information.component.html',
  styleUrl: './first-day-information.component.scss'
})
export class FirstDayInformationComponent {
  isLoadingResults = true
  items: FirstDayInformationItem[] = []
  firstDayInformationActivity = {} as ProcessActivity;
  constructor(private router: Router,
    private activityService: ActivityService,
    private serviceService : ServiceService
  ) { 
    this.firstDayInformationActivity = history.state
  }
  ngOnInit(): void {
    this.activityService.listFirstDayInformationItems().subscribe(r => {
      this.items = r.sort((a1: FirstDayInformationItem, a2: FirstDayInformationItem) => a1.id - a2.id)
      this.isLoadingResults = false
    });
  }
  private _bottomSheet = inject(MatBottomSheet);
  detail(item: FirstDayInformationItem) {
    this.removeActiveFocus();
    if(!item.addFromServices){
      this._bottomSheet.open(FirstDayInformationDetailComponent,{data :item,hasBackdrop : true,panelClass: 'full-width'});
    }else{
      this.isLoadingResults = true;
      this.serviceService.list().subscribe(services=>{
          var filtered=services.filter(s=>s.name.startsWith('Servicios'));
          if(filtered.length>0){
            this._bottomSheet.open(ServiceDetailComponent,{data :filtered[0],hasBackdrop : true, panelClass: 'full-width'}); 
          }
          this.isLoadingResults=false
      });
    }
  }
  private removeActiveFocus() {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
}
