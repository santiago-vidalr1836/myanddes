import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { SortDirection } from '@angular/material/sort';
import { Observable } from 'rxjs';
import { Tool } from '../entity/tool';

@Injectable({
  providedIn: 'root'
})
export class ToolService {
  constructor(private httpClient: HttpClient) {}
  list(): Observable<any>{
    var endpoint=environment.baseUrl+'tools'
    return this.httpClient.get(endpoint);
  }
  add(tool:Tool){
    var endpoint = environment.baseUrl+'tools'
    return this.httpClient.post(endpoint,tool)
  }
  update(tool:Tool){
    var endpoint = environment.baseUrl+'tools/'+tool.id
    return this.httpClient.put(endpoint,tool)
  }
}
