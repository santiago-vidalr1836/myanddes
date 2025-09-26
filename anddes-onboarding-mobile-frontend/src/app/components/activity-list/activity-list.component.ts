import { Component, inject } from '@angular/core';
import { ProcessActivity } from '../../entity/process-activity';
import { Router } from '@angular/router';
import { OnboardingService } from '../../service/onboarding.service';
import { ProcessActivityGroup } from '../../entity/process-activity-group';
import {
  MatBottomSheet,
  MatBottomSheetModule,
} from '@angular/material/bottom-sheet';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { Constants } from '../../entity/constants';
import { WelcomeCeoVideoComponent } from '../welcome-ceo-video/welcome-ceo-video.component';
import { ActivityService } from '../../service/activity.service';
import { Auth } from '../../entity/auth';
import { Process } from '../../entity/process';
import {ProgressSpinnerMode, MatProgressSpinnerModule} from '@angular/material/progress-spinner';
import { CommonModule, registerLocaleData } from '@angular/common';
import localeEs from '@angular/common/locales/es';

@Component({
  selector: 'app-activity-list',
  standalone: true,
  imports: [MatCardModule, MatButtonModule,MatProgressBarModule,MatIconModule,MatBottomSheetModule,MatProgressSpinnerModule,CommonModule],
  templateUrl: './activity-list.component.html',
  styleUrl: './activity-list.component.scss'
})
export class ActivityListComponent {

  private _bottomSheet = inject(MatBottomSheet);
  isLoadingResults = true
  processActivities: ProcessActivity[] = []
  processActivitiesGroups : ProcessActivityGroup[]=[]
  labels: string[]=[];

  auth  = {} as Auth;
  process = {} as Process;
  
  activityCompleted=0;
  totalActivities=1;
  progress = 0;
  constructor(private router: Router,
    private onboardinService: OnboardingService,
    private activityService : ActivityService) {
  }
  ngOnInit(): void {
    registerLocaleData(localeEs);
    var jsonAuth =localStorage.getItem("auth");
    var jsonProcess =localStorage.getItem("process");
    if(jsonAuth=== undefined || jsonProcess === undefined){
      this.router.navigate(['services']);
      return;
    }
    this.auth = JSON.parse(jsonAuth!);
    this.process = JSON.parse(jsonProcess!);
    this.loadActivities();
  }
  loadActivities(){
    this.isLoadingResults=true;
    this.onboardinService.getProcessActivities(this.auth.id,this.process.id).subscribe({
      next: value => {
        console.log(value);
        this.activityCompleted=value.filter(v=>v.completed).length;
        this.totalActivities = value.length;
        this.progress= this.activityCompleted/this.totalActivities*100.0;
        this.labels = [...new Set<string>(value.map(item=>item.activity.parent))];
        this.processActivitiesGroups = this.labels.map(item => ({
          name: item,
          order: this.order(item),
          processActivities: value.filter(pa => pa.activity.parent == item).sort((pa1,pa2)=>pa1.id-pa2.id),
          color: this.color(item),
          colorBackground : this.colorBackground(item)
        })).sort((pag1,pag2)=>pag1.order-pag2.order);
        this.isLoadingResults=false;
      },
      error: err=> console.log('Error al obtener los procesos')
    })
  }
  order(item: string): number {
    switch(item){
      case 'Antes' : return -1;
      case 'Mi primera semana' : return 1;
      default: return 0;
    }
  }
  colorBackground(item: string): string {
    switch(item){
      case 'Antes' : return '#E9F5FF';
      case 'Mi primera semana' : return '#FFF8E1';
      default: return '#DFE3E4';
    }
  }
  color(item: string): string {
    switch(item){
      case 'Antes' : return '#00539B';
      case 'Mi primera semana' : return '#EEB500';
      default: return '#383A38';
    }
  }
  activity(processActivity : ProcessActivity) {
    if(!processActivity.completed 
        && !processActivity.activity.manual
        && processActivity.activity.code!=Constants.ACTIVITY_CEO_PRESENTATION
        && processActivity.activity.code!=Constants.ACTIVITY_INDUCTION_ELEARNING
        && processActivity.activity.code!=Constants.ACTIVITY_COMPLETE_PROFILE){
        this.completeProcessActivity(processActivity);
    }
    if(processActivity.activity.code==Constants.ACTIVITY_CEO_PRESENTATION){
      this.openCeoDialog(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_COMPLETE_PROFILE){
      this.editProfile(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_FIRST_DAY_INFORMATION){
      this.openFirstDayInformation(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_KNOW_YOUR_TEAM){
      this.openKnowYourTeam(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_ON_SITE_INDUCTION){
      this.onsiteInduction(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_REMOTE_INDUCTION){
      this.remoteInduction(processActivity);
    }else if(processActivity.activity.code==Constants.ACTIVITY_INDUCTION_ELEARNING){
      this.elearning(processActivity);
    }
  }
  completeProcessActivity(processActivity: ProcessActivity) {
    this.onboardinService.updateCompletedActivities(this.auth.id,this.process.id,[processActivity]).subscribe();
  }
  openCeoDialog(processActivity : ProcessActivity){
    this.removeActiveFocus();
    this.isLoadingResults=true;
    this.activityService.listCEOPresentation().subscribe({
      next: value => {
        this.isLoadingResults=false
        this._bottomSheet.open(WelcomeCeoVideoComponent,{data : value, panelClass: 'full-width'}).afterDismissed().subscribe(result=>{
          if(result && !processActivity.completed){
            this.onboardinService.updateCompletedActivities(this.auth.id,this.process.id,[processActivity]).subscribe(()=>{
              this.loadActivities();
            });
          }
        });
      },
      error : err => console.log(err)
    })
  }
  editProfile(processActivity : ProcessActivity) {
    this.router.navigate(['profile-edit'],{state:processActivity});
  }
  openFirstDayInformation(processActivity : ProcessActivity) {
    this.router.navigate(['first-day-information-item'],{state:processActivity});
  }
  openKnowYourTeam(processActivity : ProcessActivity){
    this.router.navigate(['know-your-team'],{state:processActivity});
  }
  onsiteInduction(processActivity : ProcessActivity){
    this.router.navigate(['onsite-induction'],{state:processActivity});
  }
  remoteInduction(processActivity : ProcessActivity){
    this.router.navigate(['remote-induction'],{state:processActivity});
  }
  elearning(processActivity : ProcessActivity){
    this.router.navigate(['elearning-contents'],{state:processActivity});
  }
  private removeActiveFocus() {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
  }
}

