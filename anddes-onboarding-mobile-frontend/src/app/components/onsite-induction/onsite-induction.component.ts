import { Component, OnInit } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { OnsiteInduction } from '../../entity/onsite-induction';
import { ProcessActivity } from '../../entity/process-activity';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonModule } from '@angular/material/button';
import { Process } from '../../entity/process';
import { CommonModule, registerLocaleData } from '@angular/common';

import localeEs from '@angular/common/locales/es';

@Component({
  selector: 'app-onsite-induction',
  imports: [MatIconModule,MatProgressBarModule,MatButtonModule,CommonModule],
  templateUrl: './onsite-induction.component.html',
  styleUrl: './onsite-induction.component.scss'
})
export class OnsiteInductionComponent implements OnInit{
  isLoadingResults = false;
  onsiteInduction = {} as OnsiteInduction;
  onsiteActivity = {} as ProcessActivity;
  process = {} as Process
  constructor(private router: Router,
              private activityService: ActivityService) {
    this.onsiteActivity = history.state;
  }
  ngOnInit(): void {
    registerLocaleData(localeEs);
    var jsonProcess =localStorage.getItem("process");
    if(jsonProcess === undefined){
      this.router.navigate(['services']);
      return;
    }
    this.process = JSON.parse(jsonProcess!);
    this.activityService.listOnSiteInduction().subscribe({
      next : value => this.onsiteInduction=value,
      error : err=>console.log(err),
      complete : ()=> this.isLoadingResults=false
    })
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
}
