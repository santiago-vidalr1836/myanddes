import { HttpClient, HttpResponse } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { SortDirection } from '@angular/material/sort';
import { Observable } from 'rxjs';
import { Indicator, Process, ProcessActivity, ProcessAdd } from '../entity/process';

@Injectable({
  providedIn: 'root'
})
export class ProcessService {
  
  
  constructor(private httpClient: HttpClient) {}
  list(
    orderBy: string,
    direction: SortDirection,
    page: number,
    pageSize:number):Observable<any> {
    var endpoint=environment.baseUrl+'processes?page='+page+'&pageSize='+pageSize+'&orderBy='+orderBy+'&direction='+direction
    return this.httpClient.get(endpoint);
  }
  add(process:ProcessAdd){
    var endpoint=environment.baseUrl+'processes';
    return this.httpClient.post(endpoint,process);
  }
  update(process: Process) {
    var endpoint=environment.baseUrl+'processes/'+process.id;
    return this.httpClient.put(endpoint,process);
  }
  listActivities(processId : number):Observable<ProcessActivity[]>{
    var endpoint=environment.baseUrl+'processes/'+processId+'/activities';
    return this.httpClient.get<ProcessActivity[]>(endpoint);
  }

  changeCompleteActivity(processId:number,activityId: number, body: { completed: boolean; }) {
    var endpoint=environment.baseUrl+'processes/'+processId+'/activities/'+activityId;
    return this.httpClient.put(endpoint,body);
  }

  downloadProcess(): Observable<HttpResponse<Blob>>{
    var endpoint=environment.baseUrl+'processes/download/finished';
    return this.httpClient.get<Blob>(endpoint,{ observe: 'response', responseType: 'blob' as 'json'});  
  }
  downloadAnswers(): Observable<HttpResponse<Blob>>{
    var endpoint=environment.baseUrl+'processes/download/INDUCTION_ELEARNING/answers';
    return this.httpClient.get<Blob>(endpoint,{ observe: 'response', responseType: 'blob' as 'json'}); 
  }

  getIndicators(startDate:String , endDate:String):Observable<Indicator>{
    var endpoint=environment.baseUrl+'processes/indicators?startDate='+startDate+'&endDate='+endDate;
    return this.httpClient.get<Indicator>(endpoint);
  }
}
