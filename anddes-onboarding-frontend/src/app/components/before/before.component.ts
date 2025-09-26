import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Constants } from './../../entity/constants';
import { ActivityService } from '../../service/activity.service';
import { Activity, CEOPresentation, FirstDayInformationItem } from '../../entity/activity';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonModule } from '@angular/material/button';
import { MatDividerModule } from '@angular/material/divider';
import { forkJoin } from 'rxjs';
import { Router } from '@angular/router';
import { MatDialog } from '@angular/material/dialog';
import { WelcomeCEODialog } from './welcome-ceo-dialog/welcome.ceo.dialog';

@Component({
  selector: 'app-before',
  standalone: true,
  imports: [MatProgressBarModule,
            MatButtonModule,
            MatDividerModule
  ],
  templateUrl: './before.component.html',
  styleUrl: './before.component.scss'
})
export class BeforeComponent implements OnInit {
  activities : Activity[]=[]
  items : FirstDayInformationItem[] = []
  _CEOPresentation : CEOPresentation
  
  isLoadingResults = true
  codeActivityFirstDayInformation = Constants.ACTIVITY_FIRST_DAY_INFORMATION
  constructor(private activityService : ActivityService,
              private router : Router,
              public dialog: MatDialog,
              private cdr: ChangeDetectorRef,
  ){
  }
  ngOnInit(): void {
    forkJoin({
        activities: this.activityService.listActivitiesByParentCode(Constants.ACTIVITY_PARENT_BEFORE),
        items: this.activityService.listFirstDayInformationItem(this.codeActivityFirstDayInformation),
        _CEOPresentation: this.activityService.getCEOPresentation(Constants.ACTIVITY_CEO_PRESENTATION)
      }
    )
    .subscribe(responses=>{
      this.activities=responses.activities.filter(i=>i.editableInWeb);
      this.items = responses.items;
      this._CEOPresentation=responses._CEOPresentation;
      this.isLoadingResults=false
    })
  }
  processActivity(activity: Activity) {
    if(activity.code==Constants.ACTIVITY_CEO_PRESENTATION
      && this._CEOPresentation
    ){

      const dialogRef = this.dialog.open(WelcomeCEODialog,{data : this._CEOPresentation});
      dialogRef.afterClosed().subscribe((r:any)=>{
        if(r)
          this.activityService.updateCEOPresentation(Constants.ACTIVITY_CEO_PRESENTATION,r).subscribe();
      });  
    }
  }
  editFirstDayInformation(item : FirstDayInformationItem) {
    this.router.navigate(['first-day-information-item'],{state:item});
  }
}
