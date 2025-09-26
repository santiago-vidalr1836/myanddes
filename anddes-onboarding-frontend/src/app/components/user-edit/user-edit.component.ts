import {Component, OnInit} from '@angular/core';
import {FormControl, FormsModule, ReactiveFormsModule} from '@angular/forms';
import {MatFormFieldModule} from '@angular/material/form-field';
import {MatIconModule} from '@angular/material/icon';
import {MatSelectModule} from '@angular/material/select';
import {MatInputModule} from '@angular/material/input';
import {MatRadioModule} from '@angular/material/radio';
import {MatCheckboxModule} from '@angular/material/checkbox';
import {MatListModule } from '@angular/material/list';
import {MatAutocompleteModule} from '@angular/material/autocomplete';
import { Observable, debounceTime, distinctUntilChanged, map, of, startWith, switchMap } from 'rxjs';
import { AsyncPipe, Location } from '@angular/common';
import { MatButtonModule } from '@angular/material/button';
import { UserData } from '../../entity/user';
import { UserService } from '../../service/user.service';

@Component({
  selector: 'app-user-edit',
  standalone: true,
  imports: [FormsModule,
    ReactiveFormsModule,
    MatCheckboxModule,
    MatRadioModule,
    MatFormFieldModule,
    MatInputModule,
    MatSelectModule,
    MatIconModule,
    MatListModule,
    MatAutocompleteModule,
    MatButtonModule,
  AsyncPipe],
  templateUrl: './user-edit.component.html',
  styleUrl: './user-edit.component.scss'
})
export class UserEditComponent  implements OnInit{
  bossControl = new FormControl('');
  filteredUser: Observable<UserData[]>;
  user:UserData= new UserData();

  constructor(private location:Location,
              private userService : UserService
  ) {
   
  }
  ngOnInit() {
    if(typeof window !== 'undefined'){
      this.user=window.history.state
      if(this.user && this.user.boss){
        this.bossControl.setValue(this.user.boss.fullname)
      }
    }
    this.filteredUser = this.bossControl.valueChanges.pipe(
      startWith(''),
      debounceTime(400),
      distinctUntilChanged(),
      switchMap(val => {
            console.log(val)
            return  this._filter(val || '')
       }))
  }
  private _filter(value: string): Observable<UserData[]> {
    const filterValue = value.toLowerCase();
    return this.listUsers(filterValue).pipe(map(r=>r.users));
  }
  listUsers(
    filter:string
  ): Observable<any>{
    return this.userService.listUsers(filter,'fullname','asc',0,10);
  }
  onBossSelected($event){
    console.log($event.option.id)
    var boss=new UserData();
    boss.id=$event.option.id;
    this.user.boss=boss;
  }
  saveUser(){
    var userToUpdate : any= this.user;
    userToUpdate.bossId=this.user.boss?.id;
    this.userService.update(userToUpdate).subscribe(()=>{
      this.back()
    })
  }
  back(){
    this.location.back()
  }
}
