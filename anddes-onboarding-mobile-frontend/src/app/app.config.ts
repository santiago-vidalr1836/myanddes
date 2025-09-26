import { ApplicationConfig, provideZoneChangeDetection } from '@angular/core';
import { provideRouter } from '@angular/router';

import { environment } from '../environments/environment';
import { BrowserCacheLocation, IPublicClientApplication, InteractionType, LogLevel, PublicClientApplication } from '@azure/msal-browser';
import { MSAL_GUARD_CONFIG, MSAL_INSTANCE, MSAL_INTERCEPTOR_CONFIG, MsalBroadcastService, MsalGuard, MsalGuardConfiguration, MsalInterceptor, MsalInterceptorConfiguration, MsalService } from '@azure/msal-angular';


import { routes } from './app.routes';
import { HTTP_INTERCEPTORS, provideHttpClient, withFetch, withInterceptorsFromDi } from '@angular/common/http';
import { InterceptorService } from './service/interceptor.service';
import { provideAnimations } from '@angular/platform-browser/animations';

export function loggerCallback(logLevel: LogLevel, message: string) {
  //console.log(message);
}
export function MSALInstanceFactory(): IPublicClientApplication {
  return new PublicClientApplication({
    auth: {
      clientId: environment.msalConfig.auth.clientId,
      authority: environment.msalConfig.auth.authority,
      redirectUri: environment.msalConfig.auth.redirectUrl,
      postLogoutRedirectUri: environment.msalConfig.auth.redirectUrl
    },
    cache: {
      cacheLocation: BrowserCacheLocation.LocalStorage
    },
    system: {
      allowNativeBroker: false, // Disables WAM Broker
      loggerOptions: {
        loggerCallback,
        logLevel: LogLevel.Info,
        piiLoggingEnabled: false
      }
    }
  });
}
export function MSALInterceptorConfigFactory(): MsalInterceptorConfiguration {
  const protectedResourceMap = new Map<string, Array<string>>();
  protectedResourceMap.set(environment.apiConfig.uri, environment.apiConfig.scopes);

  return {
    interactionType: InteractionType.Redirect,
    protectedResourceMap
  };
}
export function MSALGuardConfigFactory(): MsalGuardConfiguration {
  return { 
    interactionType: InteractionType.Redirect,
    authRequest: {
      scopes: [...environment.apiConfig.scopes]
    },
    loginFailedRoute: '/login-failed'
  };
}
export const appConfig: ApplicationConfig = {
  providers: [
    provideZoneChangeDetection({ eventCoalescing: true }), 
    provideRouter(routes),
    provideAnimations(),
    provideHttpClient(withInterceptorsFromDi(), withFetch()),
    {
        provide: HTTP_INTERCEPTORS,
        useClass: MsalInterceptor,
        multi: true
    },
    {
      provide: HTTP_INTERCEPTORS,
      useClass: InterceptorService,
      multi: true
    },
    {
        provide: MSAL_INSTANCE,
        useFactory: MSALInstanceFactory
    },
    
    {
        provide: MSAL_GUARD_CONFIG,
        useFactory: MSALGuardConfigFactory
    },
    {
        provide: MSAL_INTERCEPTOR_CONFIG,
        useFactory: MSALInterceptorConfigFactory
    },
    MsalService,
    MsalGuard,
    MsalBroadcastService,
  ]
};
