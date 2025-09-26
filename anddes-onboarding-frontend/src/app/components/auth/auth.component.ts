import { Component, Inject,  OnInit } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MSAL_GUARD_CONFIG, MsalBroadcastService, MsalGuardConfiguration, MsalModule, MsalService } from '@azure/msal-angular';
import { RedirectRequest } from '@azure/msal-browser';
import { Subject } from 'rxjs';

@Component({
  selector: 'app-auth',
  standalone: true,
  imports: [MatButtonModule,
            MsalModule
  ],
  templateUrl: './auth.component.html',
  styleUrl: './auth.component.scss'
})
export class AuthComponent implements OnInit {
  
  loginDisplay = false;
  private readonly _destroying$ = new Subject<void>();
  
  constructor(@Inject(MSAL_GUARD_CONFIG) private msalGuardConfig: MsalGuardConfiguration,
              private authService: MsalService,
              private msalBroadcastService: MsalBroadcastService){}
  ngOnInit(): void {
    this.authService.handleRedirectObservable().subscribe();
    
    this.setLoginDisplay();

    this.authService.instance.enableAccountStorageEvents(); // Optional - This will enable ACCOUNT_ADDED and ACCOUNT_REMOVED events emitted when a user logs in or out of another tab or window
    
  }

  loginOffice365(){
    if (this.msalGuardConfig.authRequest){
      this.authService.loginRedirect({...this.msalGuardConfig.authRequest} as RedirectRequest);
    } else {
      this.authService.loginRedirect();
    }
  }
  setLoginDisplay() {
    console.log( this.authService.instance.getAllAccounts())
    this.loginDisplay = this.authService.instance.getAllAccounts().length > 0;
  }
  checkAndSetActiveAccount(){
    /**
     * If no active account set but there are accounts signed in, sets first account to active account
     * To use active account set here, subscribe to inProgress$ first in your component
     * Note: Basic usage demonstrated. Your app may require more complicated account selection logic
     */
    let activeAccount = this.authService.instance.getActiveAccount();

    if (!activeAccount && this.authService.instance.getAllAccounts().length > 0) {
      let accounts = this.authService.instance.getAllAccounts();
      this.authService.instance.setActiveAccount(accounts[0]);
    }
  }
}
