import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { CEOPresentation } from '../entity/ceopresentation';
import { environment } from '../../environments/environment';
import { Constants } from '../entity/constants';
import { Observable } from 'rxjs';
import { FirstDayInformationItem } from '../entity/first-day-information-item';
import { OnsiteInduction } from '../entity/onsite-induction';
import { RemoteInduction } from '../entity/remote-induction';
import { ElearningContent } from '../entity/elearning-content';
import { TeamMember } from '../entity/team-member';

@Injectable({
  providedIn: 'root'
})
export class ActivityService {

  constructor(private httpClient: HttpClient) { }

  listCEOPresentation():Observable<CEOPresentation>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_CEO_PRESENTATION;
    return <Observable<CEOPresentation>>this.httpClient.get(endpoint);
  }
  listFirstDayInformationItems():Observable<FirstDayInformationItem[]>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_FIRST_DAY_INFORMATION;
    return <Observable<FirstDayInformationItem[]>>this.httpClient.get(endpoint);
  }
  listOnSiteInduction():Observable<OnsiteInduction>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_ON_SITE_INDUCTION;
    return <Observable<OnsiteInduction>>this.httpClient.get(endpoint);
  }
  listRemoteInduction():Observable<RemoteInduction>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_REMOTE_INDUCTION;
    return <Observable<RemoteInduction>>this.httpClient.get(endpoint);
  }
  listELearningContent():Observable<ElearningContent[]>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_INDUCTION_ELEARNING;
    return <Observable<ElearningContent[]>>this.httpClient.get(endpoint);
  }
  listTeamMembers(userId:number):Observable<TeamMember[]>{
    var endpoint = environment.baseUrl + 'activities/code/'+Constants.ACTIVITY_KNOW_YOUR_TEAM+'/'+userId;
    return <Observable<TeamMember[]>>this.httpClient.get(endpoint);
  }
}
