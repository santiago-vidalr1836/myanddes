import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class FileService {
  constructor(private httpClient: HttpClient) {}
  upload(file:File): Observable<any>{
    const formData= new FormData();
    formData.append("file",file);

    var endpoint=environment.baseUrl+'files';
    return this.httpClient.post(endpoint,formData)
  }
}
