import { Component, OnInit } from '@angular/core';
import { FirstDayInformationItem } from '../../entity/activity';
import { MatButtonModule } from '@angular/material/button';
import { MatIconModule } from '@angular/material/icon';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import { ActivityService } from '../../service/activity.service';
import { Constants } from './../../entity/constants';
import { Location } from '@angular/common';
import { HtmlEditorComponent } from '../html-editor/html-editor.component';
import { Router } from '@angular/router';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';

@Component({
  selector: 'app-first-day-information-item-edit',
  standalone: true,
  imports: [MatButtonModule,
            MatIconModule,
            FormsModule,
            ReactiveFormsModule,
            MatFormFieldModule,
            HtmlEditorComponent,
            MatInputModule,
            MatSlideToggleModule
  ],
  templateUrl: './first-day-information-item-edit.component.html',
  styleUrl: './first-day-information-item-edit.component.scss'
})
export class FirstDayInformationItemEditComponent implements OnInit{
  firstDayInfomationItem : FirstDayInformationItem
  TYPE_DEFAULT = Constants.FIRST_DAY_INFORMATION_ITEM_TYPE_DEFAULT;

  constructor(private activityService : ActivityService,
              private location : Location,
              private router : Router
  ){}
  
  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.firstDayInfomationItem=window.history.state
    }
  }
  save(){
    this.activityService
        .updateFirstDayInformationItem(Constants.ACTIVITY_FIRST_DAY_INFORMATION,
                                      this.firstDayInfomationItem)
        .subscribe(()=>{
          this.router.navigate(["before"])
    })
  }
  back(){
    this.location.back()
  }
}
