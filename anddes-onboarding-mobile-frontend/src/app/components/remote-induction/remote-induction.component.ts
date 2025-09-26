import { Component } from '@angular/core';
import { RemoteInduction } from '../../entity/remote-induction';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonModule } from '@angular/material/button';
import { CommonModule, registerLocaleData } from '@angular/common';

import localeEs from '@angular/common/locales/es';
import { ProcessActivity } from '../../entity/process-activity';
import { Process } from '../../entity/process';

@Component({
  selector: 'app-remote-induction',
  imports: [MatIconModule,MatProgressBarModule,MatButtonModule,CommonModule],
  templateUrl: './remote-induction.component.html',
  styleUrl: './remote-induction.component.scss'
})
export class RemoteInductionComponent {

  isLoadingResults = false;
  remoteInduction = {} as RemoteInduction;
  remoteActivity = {} as ProcessActivity;
  process = {} as Process
  constructor(private router: Router,
              private activityService: ActivityService) {
    this.remoteActivity = history.state;              
  }
  ngOnInit(): void {
    registerLocaleData(localeEs);
    var jsonProcess =localStorage.getItem("process");
    if(jsonProcess === undefined){
      this.router.navigate(['services']);
      return;
    }
    this.process = JSON.parse(jsonProcess!);
    this.activityService.listRemoteInduction().subscribe({
      next : value => this.remoteInduction=value,
      error : err=>console.log(err),
      complete: ()=>this.isLoadingResults = false
    })
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
  openVideoCall() {
    window.open(this.process.linkRemote,"_blank");
  }
}
