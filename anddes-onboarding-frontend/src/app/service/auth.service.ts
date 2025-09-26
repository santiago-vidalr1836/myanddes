import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  constructor(private httpClient: HttpClient) {}
  
  getProfile(){
    var endpoint=environment.baseUrl+'profile?source=WEB'
    return this.httpClient.get(endpoint);
  }
}