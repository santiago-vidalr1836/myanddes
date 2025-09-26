import { Component, inject, OnInit } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { Auth } from '../../entity/auth';
import { ActivityService } from '../../service/activity.service';
import { MatBottomSheet } from '@angular/material/bottom-sheet';
import { WelcomeCeoVideoComponent } from '../welcome-ceo-video/welcome-ceo-video.component';
import { Router } from '@angular/router';
import { Process } from '../../entity/process';
import { OnboardingService } from '../../service/onboarding.service';
import { ProcessActivity } from '../../entity/process-activity';
import { Constants } from '../../entity/constants';
import { MatProgressBarModule } from '@angular/material/progress-bar';

@Component({
  selector: 'app-welcome-user',
  imports: [MatIconModule,MatButtonModule,MatProgressBarModule],
  templateUrl: './welcome-user.component.html',
  styleUrl: './welcome-user.component.scss'
})
export class WelcomeUserComponent implements OnInit{
  auth  = {} as Auth;
  isLoadingResults = false;
  btnDisabled = true;
  private _bottomSheet = inject(MatBottomSheet);
  process = {} as Process;
  processActivity = {} as ProcessActivity
  constructor(private activityService : ActivityService,
              private router : Router,
              private onboardingService : OnboardingService
  ){

  }
  ngOnInit(): void {
    var jsonAuth =localStorage.getItem("auth");
    var jsonProcess =localStorage.getItem("process");
    if(jsonAuth=== undefined || jsonProcess === undefined){
      this.router.navigate(['services']);
      return;
    }
    this.auth = JSON.parse(jsonAuth!);
    this.process = JSON.parse(jsonProcess!);
    this.onboardingService.getProcessActivities(this.auth.id,this.process.id).subscribe(r=>{
      var filtered=r.filter(pa=>pa.activity.code==Constants.ACTIVITY_CEO_PRESENTATION);
      if(filtered.length>0){
        this.processActivity=filtered[0];
        this.btnDisabled=false;
      }
    })
  }
  openCeoDialog(){
    this.removeActiveFocus();
    this.isLoadingResults=true;
    this.activityService.listCEOPresentation().subscribe({
      next: value => {
        this.isLoadingResults=false
        this._bottomSheet.open(WelcomeCeoVideoComponent,{data : value, panelClass: 'full-width',disableClose:true}).afterDismissed().subscribe(result=>{
          if(result && !this.processActivity.completed){
            this.onboardingService.updateCompletedActivities(this.auth.id,this.process.id,[this.processActivity]).subscribe();
            this.onboardingService.updateWelcomedInProcess(this.auth.id,this.process.id).subscribe();
          }
          this.router.navigate(['/activity-list']);
        });
      },
      error : err => console.log(err)
    })
  }
  private removeActiveFocus() {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
  }
}
