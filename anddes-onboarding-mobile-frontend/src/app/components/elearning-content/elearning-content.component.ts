import { Component, inject } from '@angular/core';
import { MatBottomSheet, MatBottomSheetModule } from '@angular/material/bottom-sheet';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { ElearningContent } from '../../entity/elearning-content';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { ProcessActivity } from '../../entity/process-activity';
import { OnboardingService } from '../../service/onboarding.service';
import { ProcessActivityContent } from '../../entity/process-activity-content';
import { Auth } from '../../entity/auth';
import { Process } from '../../entity/process';
import localeEs from '@angular/common/locales/es';
import { CommonModule, registerLocaleData } from '@angular/common';
import { ElearningContentCardComponent } from '../elearning-content-card/elearning-content-card.component';
import { SnackbarService } from '../../service/snackbar.service';
import { ProcessActivityContentDTO } from '../../entity/process-activity-content-dto';
import { Constants } from '../../entity/constants';

@Component({
  selector: 'app-elearning-content',
  imports: [MatCardModule, MatButtonModule, MatProgressBarModule, MatIconModule,MatBottomSheetModule,CommonModule],
  templateUrl: './elearning-content.component.html',
  styleUrl: './elearning-content.component.scss'
})
export class ElearningContentComponent {
  isLoadingResults = true
  elearnings: ElearningContent[] = []
  inductionActivity = {} as ProcessActivity
  processActivityContents:ProcessActivityContent[]=[]
  auth  = {} as Auth;
  process = {} as Process;
  
  constructor(private router: Router,
    private activityService: ActivityService,
    private onboardingService : OnboardingService,
    private snackbarService : SnackbarService
  ) { 
    this.inductionActivity = history.state;
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
    if(!this.inductionActivity || !this.inductionActivity.id){
      this.onboardingService.getProcessActivities(this.auth.id,this.process.id).subscribe(r=>{
        var filtered=r.filter(pa=>pa.activity.code==Constants.ACTIVITY_INDUCTION_ELEARNING);
        if(filtered.length>0){
          this.inductionActivity=filtered[0];
          this.loadContent();
        }
      })
    }else{
      this.loadContent();
    }
  }
  loadContent(){
    this.isLoadingResults = true;
    this.processActivityContents=[];
    this.activityService.listELearningContent().subscribe(r => {
      this.elearnings = r;
      this.elearnings.forEach(e=>{
        this.onboardingService.getProcessActivityContent(this.auth.id,this.process.id,this.inductionActivity.id,e.id).subscribe(processActivityContentResponse=>{
          if(!processActivityContentResponse){
            processActivityContentResponse = {} as ProcessActivityContent;
            processActivityContentResponse.content = e;
            processActivityContentResponse.progress=0;
            processActivityContentResponse.result=0;
          }
          this.processActivityContents.push(processActivityContentResponse);
          this.processActivityContents.sort((pac1,pac2)=>pac1.content.position-pac2.content.position)
        })  
      });      
      this.isLoadingResults = false
    });
  }
  private _bottomSheet = inject(MatBottomSheet);
  private removeActiveFocus() {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
  }
  detail(processActivityContent: ProcessActivityContent) {
    this.removeActiveFocus();
    if(!processActivityContent.id){
      this.isLoadingResults=true;
      this.onboardingService.createNewProcessActivityContent(this.auth.id,this.process.id,this.inductionActivity.id,processActivityContent.content.id).subscribe(
        {
          next : () => {
            this.onboardingService.getProcessActivityContent(this.auth.id,this.process.id,this.inductionActivity.id,processActivityContent.content.id).subscribe({
              next : r=> this.showProcessActivityContentCard(r),
              error : err=>this.snackbarService.error('Ocurrio un error inesperado')
            })
          },
          error : err=>this.snackbarService.error('Ocurrio un error inesperado'),
          complete : ()=>this.isLoadingResults = false
        }
      )
    }else{
      this.showProcessActivityContentCard(processActivityContent);
    }
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
  showProcessActivityContentCard(processActivityContent:ProcessActivityContent){
    console.log(processActivityContent);
    this.isLoadingResults=false;
    var dto = {} as ProcessActivityContentDTO;
    dto.userId=this.auth.id;
    dto.processId = this.process.id;
    dto.processActivityId = this.inductionActivity.id;
    dto.processActivityContent = processActivityContent;
    this._bottomSheet.open(ElearningContentCardComponent,{data :dto,hasBackdrop : true,panelClass: 'full-width'}).afterDismissed().subscribe(()=>this.loadContent());
  }
}
