import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';
import { Auth } from '../entity/auth';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private httpClient: HttpClient) {}

  getProfile():Observable<Auth>{
    var endpoint=environment.baseUrl+'profile'
    return <Observable<Auth>>this.httpClient.get(endpoint);
  }
}
