import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Service, ServiceDetail } from '../entity/service';

@Injectable({
  providedIn: 'root'
})
export class ServiceService {
  constructor(private httpClient: HttpClient) {}
  list():Observable<any> {
    var endpoint=environment.baseUrl+'services'
    return this.httpClient.get(endpoint);
  }
  update(service:Service){
    var endpoint=environment.baseUrl+'services/'+service.id;
    return this.httpClient.put(endpoint,service);
  }
  updateDetail(service:Service){
    var endpoint= environment.baseUrl+'services/'+service.id+'/details';
    return this.httpClient.put(endpoint,service.details);
  }
}
