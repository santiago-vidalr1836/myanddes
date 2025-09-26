import { AsyncPipe,Location } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { provideMomentDateAdapter } from '@angular/material-moment-adapter';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatButtonModule } from '@angular/material/button';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { Process, ProcessActivity } from '../../entity/process';
import { Router } from '@angular/router';
import { ProcessService } from '../../service/process.service';
import {MatCheckboxModule} from '@angular/material/checkbox';

@Component({
  selector: 'app-process-edit',
  standalone: true,
  providers: [
    {provide: MAT_DATE_LOCALE, useValue: 'es-ES'},
    provideMomentDateAdapter(),
  ],
  imports: [MatIconModule,
            MatButtonModule,
            FormsModule,
            MatFormFieldModule,
            ReactiveFormsModule,
            MatInputModule,
            MatDatepickerModule,
            MatAutocompleteModule,
            MatCheckboxModule,
            AsyncPipe],
  templateUrl: './process-edit.component.html',
  styleUrl: './process-edit.component.scss'
})
export class ProcessEditComponent implements OnInit{
  process : Process = new Process()
  activities : ProcessActivity[]
  parentActivities : any
  properties : string[] 

  constructor(private router: Router,
    private location:Location,
    private processService : ProcessService){
  }
  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.process=window.history.state
      this.processService.listActivities(this.process.id).subscribe(r=>{
        this.activities=r
        const parentActivities = this.activities.reduce((parentActivities, item) => {
          const activity = (parentActivities[item.activity.parent] || []);
          activity.push(item);
          parentActivities[item.activity.parent] = activity;
          return parentActivities;
        }, {});
        this.parentActivities = parentActivities;
        this.properties = Object.keys(this.parentActivities).sort((a,b)=> a.localeCompare(b));
      })
    }
  }
  back() {
    this.location.back()
  }
  save(){
    this.processService.update(this.process).subscribe(()=>{
      this.router.navigate(['processes']);
    })
  }
  updateAllComplete(property: string,activity : ProcessActivity) {
    this.processService.changeCompleteActivity(this.process.id,activity.id,{completed:activity.completed}).subscribe()
    return this.parentActivities[property].every(t => t.completed)
  }
  someComplete(property: string): unknown {
    return this.parentActivities[property].filter(t => t.completed).length > 0 &&
          !this.parentActivities[property].every(t => t.completed)
  }
  allComplete(property: string): unknown {
    return this.parentActivities[property].every(t => t.completed)
  }
}
