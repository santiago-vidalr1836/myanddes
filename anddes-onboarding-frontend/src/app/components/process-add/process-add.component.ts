import { Component , OnInit } from '@angular/core';
import {provideMomentDateAdapter} from '@angular/material-moment-adapter';
import { AsyncPipe, Location } from '@angular/common';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { Router } from '@angular/router';
import { ProcessAdd } from '../../entity/process';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { UserData } from '../../entity/user';
import { Observable, debounceTime, distinctUntilChanged, map, startWith, switchMap } from 'rxjs';
import { UserService } from '../../service/user.service';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import 'moment/locale/es-mx';
import { ProcessService } from '../../service/process.service';

@Component({
  selector: 'app-process-add',
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
            AsyncPipe],
  templateUrl: './process-add.component.html',
  styleUrl: './process-add.component.scss'
})
export class ProcessAddComponent implements OnInit{
  process : ProcessAdd= new ProcessAdd()
  userControl = new FormControl('');
  filteredUser: Observable<UserData[]>;

  constructor(private router: Router,
              private location:Location,
              private usesService : UserService,
              private processService : ProcessService){

  }
  ngOnInit(): void {
    this.filteredUser = this.userControl.valueChanges.pipe(
      startWith(''),
      debounceTime(400),
      distinctUntilChanged(),
      switchMap(val => {
            return  this._filter(val || '')
       }))
  }
  private _filter(value: string): Observable<UserData[]> {
    const filterValue = value.toLowerCase();
    return this.usesService.listUsersAndOnItinerary(false,filterValue,'fullname','asc',0,10)
          .pipe(map(r=>r.users));
  }
  back() {
    this.location.back()
  }
  onUserSelected($event){
    this.process.userId=$event.option.id;
  }
  save(){
    this.processService.add(this.process).subscribe(()=>{
      this.router.navigate(['processes']);
    })
  }
}

