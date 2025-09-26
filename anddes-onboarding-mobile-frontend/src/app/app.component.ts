import { Component, Inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatButtonModule } from '@angular/material/button';
import { MatDrawerMode, MatSidenavModule } from '@angular/material/sidenav';
import { MatRadioModule } from '@angular/material/radio';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatDividerModule } from '@angular/material/divider';
import { NavigationEnd, Router, RouterLink, RouterOutlet } from '@angular/router';
import { MatSnackBarModule } from '@angular/material/snack-bar';

import { FormsModule, ReactiveFormsModule } from '@angular/forms';

//import { BreakpointObserver } from '@angular/cdk/layout';
import { BooleanInput } from '@angular/cdk/coercion';

import { MSAL_GUARD_CONFIG, MsalModule, MsalGuardConfiguration, MsalService, MsalBroadcastService } from '@azure/msal-angular';
import { InteractionStatus, RedirectRequest, EventMessage, EventType } from '@azure/msal-browser';

import { TreeNode } from './entity/tree-node';
import { filter, Subject, takeUntil } from 'rxjs';
import { ProfileService } from './service/profile.service';
import { Auth } from './entity/auth';
import { OnboardingService } from './service/onboarding.service';
import { SnackbarService } from './service/snackbar.service';
import { Process } from './entity/process';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, CommonModule, MsalModule, RouterLink, MatToolbarModule,
    MatButtonModule, MatMenuModule, MatIconModule, MatSidenavModule, MatRadioModule,
    FormsModule, ReactiveFormsModule, MatDividerModule, MatSnackBarModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'Mi Anddes';
  isOnProcess = false;
  mdcBackdrop: BooleanInput = true;
  drawerMode: MatDrawerMode = "over";
  //mode = new FormControl('over' as MatDrawerMode);
  //readonly breakpoint$;
  isScreenWelcomed = false;
  isIframe = false;
  loginDisplay = false;
  private readonly _destroying$ = new Subject<void>();

  constructor(
    /*private breakpointObserver: BreakpointObserver,*/
    @Inject(MSAL_GUARD_CONFIG) private msalGuardConfig: MsalGuardConfiguration,
    private authService: MsalService,
    private msalBroadcastService: MsalBroadcastService,
    private profileService: ProfileService,
    private snackbarService : SnackbarService,
    private router: Router,
    private processService : OnboardingService,
  ) {
    /*this.breakpoint$ = this.breakpointObserver.observe(['(max-width: 768px)'])
    this.breakpoint$.subscribe(() =>
      this.breakpointChanges()
    );*/
  }
  ngOnInit(): void {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)  
    ).subscribe((event: NavigationEnd) => {
      if (event.url.substring(this.router.url.length - 13, event.url.length) === '/welcome-user') {
        this.isScreenWelcomed = true;
      }else this.isScreenWelcomed = false;
    });
    this.authService.handleRedirectObservable().subscribe();

    //this.isIframe = false;//window !== window.parent && !window.opener; // Remove this line to use Angular Universal
    if (typeof window !== "undefined") {
      this.isIframe = window !== window.parent && !window.opener;
    }
    //this.setLoginDisplay();

    this.authService.instance.enableAccountStorageEvents(); // Optional - This will enable ACCOUNT_ADDED and ACCOUNT_REMOVED events emitted when a user logs in or out of another tab or window
    this.msalBroadcastService.msalSubject$
      .pipe(
        filter((msg: EventMessage) => msg.eventType === EventType.ACCOUNT_ADDED || msg.eventType === EventType.ACCOUNT_REMOVED),
      )
      .subscribe((result: EventMessage) => {
        console.log('this.msalBroadcastService.msalSubject$')
        if (this.authService.instance.getAllAccounts().length === 0) {
          window.location.pathname = "/";
        } else {
          this.setLoginDisplay();
        }
      });
    this.msalBroadcastService.inProgress$
      .pipe(
        filter((status: InteractionStatus) => status === InteractionStatus.None),
        takeUntil(this._destroying$)
      )
      .subscribe(() => {
        this.setLoginDisplay();
        this.checkAndSetActiveAccount();
      })
  }
  setLoginDisplay() {
    this.loginDisplay = this.authService.instance.getAllAccounts().length > 0;

    if (this.loginDisplay) {
      setTimeout(() => {
        this.profileService.getProfile().subscribe({
          next: value => this.onSuccess(value),
          error: err => this.loginDisplay = false
        });
      }, 700)
    }
  }
  opened=false
  /*breakpointChanges(): void {
    if (this.breakpointObserver.isMatched('(max-width: 768px)')) {
      this.drawerMode = "over";
      this.mdcBackdrop = true;
      this.opened=false
    } else {
      this.drawerMode = "push";
      this.mdcBackdrop = false;
      this.opened=true;
    }
  }*/
  hasChild = (_: number, node: TreeNode) => !!node.children && node.children.length > 0;
  ngOnDestroy(): void {
    this._destroying$.next(undefined);
    this._destroying$.complete();
  }
  logout(popup?: boolean) {
    if (popup) {
      this.authService.logoutPopup({
        mainWindowRedirectUri: "/"
      });
    } else {
      this.authService.logoutRedirect();
    }
  }
  loginRedirect() {
    if (this.msalGuardConfig.authRequest) {
      this.authService.loginRedirect({ ...this.msalGuardConfig.authRequest } as RedirectRequest);
    } else {
      this.authService.loginRedirect();
    }
  }
  checkAndSetActiveAccount() {
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
  onSuccess(auth: Auth) {
    localStorage.setItem('auth', JSON.stringify(auth));
    this.processService.getOnboardingProcess(auth.id).subscribe({
      next: process => this.onSuccessProcess(auth.id, process),
      error: err => this.onErrorProcess()
    })
  }
  onErrorProcess(): void {
    console.log('onError');
    this.router.navigate(['/services']);
  }
  onSuccessProcess(userId: number, process: Process): void {
    console.log('onSuccessProcess');
    console.log(process)
    localStorage.setItem('process', JSON.stringify(process));
    if (process == null) {
      this.isOnProcess=false;
      this.router.navigate(['/services']);
    } else if (!process.welcomed) {
      this.isOnProcess=true;
      this.processService.updateWelcomedInProcess(userId, process.id).subscribe();
      this.router.navigate(['/welcome-user']);
    } else {
      this.isOnProcess=true;
      this.router.navigate(['/activity-list']);
    }
  }
  onError(err: any) {
    console.log(err)
    this.router.navigate(['/']);
    this.snackbarService.error('No tiene acceso a la aplicacion.')
  }
}
