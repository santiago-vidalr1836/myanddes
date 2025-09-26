import { HttpEvent, HttpHandler, HttpHeaders, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MsalService } from '@azure/msal-angular';
import { Observable, switchMap } from 'rxjs';
import { environment } from '../../environments/environment';
import { AuthenticationResult } from '@azure/msal-browser';

@Injectable({
  providedIn: 'root'
})
export class InterceptorService implements HttpInterceptor{

  constructor(private msalService: MsalService) { }
  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    const scopes = [environment.msalConfig.auth.clientId+'/.default']
    const account = this.msalService.instance.getAllAccounts()[0];
    return this.msalService.acquireTokenSilent({ scopes, account }).pipe(
        switchMap((result: AuthenticationResult) => {
        //console.log(result.accessToken) 
        const headers = new HttpHeaders({
            authorization: `Bearer ${result.accessToken}`
        });
        const requestClone = req.clone({ headers });
            return next.handle(requestClone);
        })
    );
  }
}
