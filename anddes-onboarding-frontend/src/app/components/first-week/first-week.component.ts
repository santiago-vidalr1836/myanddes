import { Component, OnInit } from '@angular/core';
import { ELearningContent } from '../../entity/activity';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { Router } from '@angular/router';
import { ActivityService } from '../../service/activity.service';
import { Constants } from '../../entity/constants';

@Component({
  selector: 'app-first-week',
  standalone: true,
  imports: [MatCardModule,
            MatButtonModule,
            MatProgressBarModule,
            MatIconModule],
  templateUrl: './first-week.component.html',
  styleUrl: './first-week.component.scss'
})
export class FirstWeekComponent implements OnInit{
  contents : ELearningContent[]=[]
  isLoadingResults = false
  constructor(private router: Router,
              private activityService : ActivityService) {}
  ngOnInit(): void {
    this.activityService.listELearningContent(Constants.ACTIVITY_INDUCTION_ELEARNING).subscribe(r=>{
      this.contents=r
      this.isLoadingResults=false
    });
  }
  add() {
    this.router.navigate(['elearning-content/add']);
  }  
  edit(content: ELearningContent) {
    this.router.navigate(['elearning-content/edit'],{state:content});
  }
}
