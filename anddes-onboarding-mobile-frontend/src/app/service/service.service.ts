import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';
import { Service } from '../entity/service';

@Injectable({
  providedIn: 'root'
})
export class ServiceService {

  constructor(private httpClient: HttpClient) { }
  list(): Observable<Service[]> {
    var endpoint = environment.baseUrl + 'services'
    return <Observable<Service[]>>this.httpClient.get(endpoint);
  }
}
