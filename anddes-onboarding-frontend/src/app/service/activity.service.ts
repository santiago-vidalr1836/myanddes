import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Activity, CEOPresentation, ELearningContent, FirstDayInformationItem, OnSiteInduction, RemoteInduction } from '../entity/activity';

@Injectable({
  providedIn: 'root'
})
export class ActivityService {
  constructor(private httpClient: HttpClient) {}
  
  listActivitiesByParentCode(parentCode : string):Observable<Activity[]> {
    var endpoint=environment.baseUrl+'activities/parent/'+parentCode
    return this.httpClient.get<Activity[]>(endpoint);
  }

  getCEOPresentation(codeCEOPresentation : string):Observable<CEOPresentation>{
    var endpoint=environment.baseUrl+'activities/code/'+codeCEOPresentation
    return this.httpClient.get<CEOPresentation>(endpoint);
  }
  updateCEOPresentation(codeCEOPresentation : string , _CEOPresentation: CEOPresentation){
    var endpoint=environment.baseUrl+'activities/code/'+codeCEOPresentation+"/"+_CEOPresentation.id
    return this.httpClient.put(endpoint,_CEOPresentation);
  }


  listFirstDayInformationItem(codeActivityFirstDayInformation : string):Observable<FirstDayInformationItem[]> {
    var endpoint=environment.baseUrl+'activities/code/'+codeActivityFirstDayInformation
    return this.httpClient.get<FirstDayInformationItem[]>(endpoint);
  }
  updateFirstDayInformationItem(codeActivityFirstDayInformation : string,firstDayInformationItem : FirstDayInformationItem){
    var endpoint=environment.baseUrl+'activities/code/'+codeActivityFirstDayInformation+"/"+firstDayInformationItem.id
    return this.httpClient.put(endpoint,firstDayInformationItem);
  }

  
  getOnSiteInduction(codeOnSiteInduction : string):Observable<OnSiteInduction>{
    var endpoint=environment.baseUrl+'activities/code/'+codeOnSiteInduction
    return this.httpClient.get<OnSiteInduction>(endpoint);
  }
  updateOnSiteInduction(codeOnSiteInduction : string , onSiteInduction: OnSiteInduction){
    var endpoint=environment.baseUrl+'activities/code/'+codeOnSiteInduction+"/"+onSiteInduction.id
    return this.httpClient.put(endpoint,onSiteInduction);
  }


  getRemoteInduction(codeRemoteInduction : string):Observable<RemoteInduction>{
    var endpoint=environment.baseUrl+'activities/code/'+codeRemoteInduction
    return this.httpClient.get<RemoteInduction>(endpoint);
  }
  updateRemoteInduction(codeRemoteInduction : string , remoteInduction: RemoteInduction){
    var endpoint=environment.baseUrl+'activities/code/'+codeRemoteInduction+"/"+remoteInduction.id
    return this.httpClient.put(endpoint,remoteInduction);
  }

  listELearningContent(codeElearningInduction:string){
    var endpoint=environment.baseUrl+'activities/code/'+codeElearningInduction
    return this.httpClient.get<ELearningContent[]>(endpoint);
  }
  saveELearningContent(codeElearningInduction:string, content: ELearningContent){
    var endpoint=environment.baseUrl+'activities/code/'+codeElearningInduction
    return this.httpClient.post<ELearningContent[]>(endpoint,content);
  }
  updateELearningContent(codeElearningInduction : string , content: ELearningContent){
    var endpoint=environment.baseUrl+'activities/code/'+codeElearningInduction+"/"+content.id
    return this.httpClient.put(endpoint,content);
  }
}
