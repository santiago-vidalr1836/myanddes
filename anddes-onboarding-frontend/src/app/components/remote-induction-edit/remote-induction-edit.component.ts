import { Location } from '@angular/common';
import { Component } from '@angular/core';
import { Activity, RemoteInduction } from '../../entity/activity';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { ActivityService } from '../../service/activity.service';
import { Router } from '@angular/router';
import { Constants } from '../../entity/constants';

@Component({
  selector: 'app-remote-induction-edit',
  standalone: true,
  imports: [MatIconModule,
            FormsModule,
            ReactiveFormsModule,
            MatFormFieldModule,
            MatInputModule,
            MatButtonModule],
  templateUrl: './remote-induction-edit.component.html',
  styleUrl: './remote-induction-edit.component.scss'
})
export class RemoteInductionEditComponent {
  activity : Activity
  remoteInduction : RemoteInduction

  constructor(private activityService : ActivityService,
              private location : Location,
              private router : Router){}


  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.activity=window.history.state
      this.activityService.getRemoteInduction(Constants.ACTIVITY_REMOTE_INDUCTION).subscribe(r=>{
        this.remoteInduction = r
      })
    }
  }
  back(){
    this.location.back()
  }
  save(){
    this.activityService.updateRemoteInduction(Constants.ACTIVITY_REMOTE_INDUCTION,this.remoteInduction).subscribe(()=>{
      this.router.navigate(["first-day"])
    })  
  }
}
