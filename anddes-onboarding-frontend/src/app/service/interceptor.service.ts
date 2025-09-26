import { HttpEvent, HttpHandler, HttpHeaders, HttpInterceptor, HttpRequest } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { MsalService } from '@azure/msal-angular';
import { AuthenticationResult } from '@azure/msal-browser';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class InterceptorService implements HttpInterceptor {

  constructor(private msalService: MsalService) { }

    intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {

    const scopes = [environment.msalConfig.auth.clientId+'/.default']
    const account = this.msalService.instance.getAllAccounts()[0];
    return this.msalService.acquireTokenSilent({ scopes, account }).pipe(
        switchMap((result: AuthenticationResult) => {
        const headers = new HttpHeaders({
            authorization: `Bearer ${result.accessToken}`
        });
        const requestClone = req.clone({ headers });
            return next.handle(requestClone);
        })
    );
    }
  /*intercept2(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    this.loaderService.show();
    let intReq = req;
    
    if (token != null) {
      intReq = req.clone({ headers: req.headers.set('Authorization', 'Bearer ' + token)});
    }
    return next.handle(intReq).pipe(catchError((err: HttpErrorResponse)=>{
      if(err.status === 401){
        this.router.navigate(['/'], {replaceUrl: true});
      }
      return throwError(err);
    }), finalize(()=>{this.loaderService.hide()}));
  }*/
}
