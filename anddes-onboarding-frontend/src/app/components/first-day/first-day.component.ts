import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { Activity } from '../../entity/activity';
import { MatDialog } from '@angular/material/dialog';
import { ActivityService } from '../../service/activity.service';
import { Router } from '@angular/router';
import { Constants } from '../../entity/constants';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatDividerModule } from '@angular/material/divider';
import { MatButtonModule } from '@angular/material/button';

@Component({
  selector: 'app-first-day',
  standalone: true,
  imports: [MatProgressBarModule,
            MatDividerModule,
            MatButtonModule
  ],
  templateUrl: './first-day.component.html',
  styleUrl: './first-day.component.scss'
})
export class FirstDayComponent implements OnInit {
  isLoadingResults = false
  activities : Activity[]=[]
  constructor(private activityService : ActivityService,
              private router : Router,
              public dialog: MatDialog,
              private cdr: ChangeDetectorRef){}
  ngOnInit(): void {
    this.activityService.listActivitiesByParentCode(Constants.ACTIVITY_PARENT_FIRST_DAY).subscribe(r=>{
      this.activities=r.filter(i=>i.editableInWeb)
      this.isLoadingResults = false
    })
  }
  processActivity(activity: Activity) {
    if(activity.code == Constants.ACTIVITY_ON_SITE_INDUCTION)
      this.router.navigate(['on-site-induction-edit'],{state:activity});
    else if (activity.code == Constants.ACTIVITY_REMOTE_INDUCTION)
      this.router.navigate(['remote-induction-edit'],{state:activity});
  }
}
