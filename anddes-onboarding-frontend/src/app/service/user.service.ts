import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { SortDirection } from '@angular/material/sort';
import { Observable } from 'rxjs';
import { UserData } from '../entity/user';

@Injectable({
  providedIn: 'root'
})
export class UserService {
  constructor(private httpClient: HttpClient) {}
  listUsers(
    filter:string,
    orderBy: string,
    direction: SortDirection,
    page: number,
    pageSize:number):Observable<any> {
    var endpoint=environment.baseUrl+'users?filter='+filter+
    '&page='+page+'&pageSize='+pageSize+'&orderBy='+orderBy+'&direction='+direction
    return this.httpClient.get(endpoint);
  }
  loadUsers(list:any[]){
    var endpoint=environment.baseUrl+'users/load';
    return this.httpClient.post(endpoint,list);
  }
  update(user:any){
    var endpoint=environment.baseUrl+'users/'+user.id;
    return this.httpClient.put(endpoint,user);
  }
  listUsersAndOnItinerary(
    onItinerary:boolean,
    filter:string,
    orderBy: string,
    direction: SortDirection,
    page: number,
    pageSize:number):Observable<any> {
    var endpoint=environment.baseUrl+'users/onItinerary/'+onItinerary+'?filter='+filter+
    '&page='+page+'&pageSize='+pageSize+'&orderBy='+orderBy+'&direction='+direction
    return this.httpClient.get(endpoint);
  }
}
