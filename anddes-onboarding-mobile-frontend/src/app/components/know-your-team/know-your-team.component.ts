import { Component, inject } from '@angular/core';
import { TeamMember } from '../../entity/team-member';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { MatBottomSheet, MatBottomSheetModule } from '@angular/material/bottom-sheet';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { Auth } from '../../entity/auth';
import { MatDividerModule } from '@angular/material/divider';
import { CommonModule } from '@angular/common';
import { ToolService } from '../../service/tool.service';
import { Tool } from '../../entity/tool';
import { SnackbarService } from '../../service/snackbar.service';
import { ProcessActivity } from '../../entity/process-activity';

@Component({
  selector: 'app-know-your-team',
  imports: [MatCardModule, MatButtonModule, MatProgressBarModule, MatIconModule,MatBottomSheetModule,MatDividerModule,CommonModule],
  templateUrl: './know-your-team.component.html',
  styleUrl: './know-your-team.component.scss'
})
export class KnowYourTeamComponent {
  auth  = {} as Auth;
  isLoadingResults = true
  members: TeamMember[] = []
  knowYourTeamActivity = {} as ProcessActivity;
  constructor(private router: Router,
    private activityService: ActivityService,
    private toolService : ToolService,
    private snackBarService : SnackbarService
  ) { 
    this.knowYourTeamActivity=history.state;
  }
  ngOnInit(): void {
    var jsonAuth =localStorage.getItem("auth");
    if(jsonAuth=== undefined){
      this.router.navigate(['services']);
      return;
    }
    this.auth = JSON.parse(jsonAuth!);
    this.activityService.listTeamMembers(this.auth.id).subscribe(r => {
      this.members = r;
      this.isLoadingResults = false
    });
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
  openDirectory(){
    this.isLoadingResults=true;
    this.toolService.list().subscribe({
      next: response=> this.onToolResponse(response),
      error: err=>this.onToolErrorResponseError()
    })
  }
  onToolResponse(responses:Tool[]){
    this.isLoadingResults=false;
    if(responses && responses.length>0){
      window.open(responses[0].link, "_blank");
    }else{
      this.onToolErrorResponseError();
    }
  }
  onToolErrorResponseError(){
    this.isLoadingResults=false;
    this.snackBarService.error('No se ha encontrado el directorio');
  }
}
