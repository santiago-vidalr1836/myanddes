import { Location } from '@angular/common'
import { Component, OnInit } from '@angular/core';
import { ActivityService } from '../../service/activity.service';
import { Activity, OnSiteInduction } from '../../entity/activity';
import { Constants } from '../../entity/constants';
import { MatIconModule } from '@angular/material/icon';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatButtonModule } from '@angular/material/button';
import { Router } from '@angular/router';

@Component({
  selector: 'app-on-site-induction-edit',
  standalone: true,
  imports: [MatIconModule,
            FormsModule,
            ReactiveFormsModule,
            MatFormFieldModule,
            MatInputModule,
            MatButtonModule
  ],
  templateUrl: './on-site-induction-edit.component.html',
  styleUrl: './on-site-induction-edit.component.scss'
})
export class OnSiteInductionEditComponent implements OnInit{
  activity : Activity
  onSiteInduction : OnSiteInduction
  constructor(private activityService : ActivityService,
              private location : Location,
              private router : Router,
  ){

  }
  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.activity=window.history.state
      this.activityService.getOnSiteInduction(Constants.ACTIVITY_ON_SITE_INDUCTION).subscribe(r=>{
        console.log(r)
        this.onSiteInduction = r
      })
    }
  }
  back(){
    this.location.back()
  }
  save(){
    this.activityService.updateOnSiteInduction(Constants.ACTIVITY_ON_SITE_INDUCTION,this.onSiteInduction).subscribe(()=>{
      this.router.navigate(["first-day"])
    })
  }
}
