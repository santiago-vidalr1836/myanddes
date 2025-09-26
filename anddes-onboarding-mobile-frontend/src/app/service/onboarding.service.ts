import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Process } from '../entity/process';
import { ProcessActivity } from '../entity/process-activity';
import { ProcessActivityContent, ProcessActivityContentResult } from '../entity/process-activity-content';

@Injectable({
  providedIn: 'root'
})
export class OnboardingService {

  constructor(private httpClient: HttpClient) { }

  getOnboardingProcess(userId: number):Observable<Process> {
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/';
    return <Observable<Process>>this.httpClient.get(endpoint);
  }
  updateWelcomedInProcess(userId: number,processId:number){
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/welcomed';
    return this.httpClient.put(endpoint,null);
  }
  getProcessActivities(userId: number,processId:number):Observable<ProcessActivity[]>{
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities';
    return <Observable<ProcessActivity[]>>this.httpClient.get(endpoint);
  }
  updateCompletedActivities(userId:number,processId:number,activities:ProcessActivity[]){
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities';
    return this.httpClient.put(endpoint,activities);
  }

  getProcessActivityContent(userId:number,processId:number,processActivityId : number,elearningConteId:number):Observable<ProcessActivityContent>{
    ///{userId}/process/{processId}/activities/{processActivityId}/content
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities/'+processActivityId+'/content?eLearningContentId='+elearningConteId;
    return <Observable<ProcessActivityContent>>this.httpClient.get(endpoint);
  }

  createNewProcessActivityContent(userId:number,processId:number,processActivityId : number,elearningConteId:number){
    ///{userId}/process/{processId}/activities/{processActivityId}/content
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities/'+processActivityId+'/content?eLearningContentId='+elearningConteId;
    return this.httpClient.post(endpoint,{});
  }

  updateReadAndAnswer(userId:number,processId:number,processActivityId : number,processActivityContentId:number,processActivityContentCardId:number,answer : any){
    ///{userId}/process/{processId}/activities/{processActivityId}/content/{processActivityContentId}/card/{processActivityContentCardId}
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities/'+processActivityId+'/content/'+processActivityContentId+'/card/'+processActivityContentCardId;
    return this.httpClient.put(endpoint,answer);
  }

  getResult(userId:number,processId:number,processActivityId : number,processActivityContentId:number):Observable<ProcessActivityContentResult>{
    ///{userId}/process/{processId}/activities/{processActivityId}/content/{processActivityContentId}/result"
    var endpoint = environment.baseUrl + 'onboarding/'+userId+'/process/'+processId+'/activities/'+processActivityId+'/content/'+processActivityContentId+'/result';
    return <Observable<ProcessActivityContentResult>>this.httpClient.post(endpoint,{});
  }
}
