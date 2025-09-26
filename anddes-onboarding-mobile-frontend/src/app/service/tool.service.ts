import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ToolService {
  constructor(private httpClient: HttpClient) {}
  list(): Observable<any>{
    var endpoint=environment.baseUrl+'tools'
    return this.httpClient.get(endpoint);
  }
}
