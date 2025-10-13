import { Component, Inject, OnDestroy, OnInit } from '@angular/core';
import {MatIconModule} from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatButtonModule } from '@angular/material/button';
import { MatDrawerMode, MatSidenavModule} from '@angular/material/sidenav';
import { MatRadioModule } from '@angular/material/radio';
import { MatToolbarModule } from '@angular/material/toolbar';
import {MatDividerModule} from '@angular/material/divider';
import {MatTreeNestedDataSource, MatTreeModule} from '@angular/material/tree';

import { MSAL_GUARD_CONFIG, MsalModule,MsalGuardConfiguration, MsalService, MsalBroadcastService } from '@azure/msal-angular';
import { AuthenticationResult, InteractionStatus, PopupRequest, RedirectRequest, EventMessage, EventType  } from '@azure/msal-browser';
import { Subject, filter, takeUntil } from 'rxjs';
import { CommonModule } from '@angular/common';
import { BooleanInput } from '@angular/cdk/coercion';
import {BreakpointObserver} from '@angular/cdk/layout';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { QuillEditorComponent } from 'ngx-quill';
import { Router, RouterLink, RouterOutlet } from '@angular/router';
import { NestedTreeControl } from '@angular/cdk/tree';
import { TreeNode} from './entity/tree.node';
import { MatSnackBarModule } from '@angular/material/snack-bar';
import { AuthService } from './service/auth.service';
import { SnackbarService } from './service/snackbar.service';

const TREE_DATA: TreeNode[] = [
  {
    id : 0,
    name: 'ONBOARDING',
    url : '',
    children: [
      { 
        id : 0,
        name: 'PROCESOS',
        url : 'processes'
      }, 
      { 
        id : 0,
        name: 'ITINERARIO',
        url : '',
        children: [
          {
            id : 0,
            name: 'ANTES',
            url : 'before'
          },
          {
            id : 0,
            name: 'MI PRIMER DIA',
            url : 'first-day'
          },
          {
            id : 0,
            name: 'MI PRIMERA SEMANA',
            url : 'first-week'
          }
        ]
      }
    ],
  }
];
const TREE_DATA_REPORTES: TreeNode[] = [
  {
    id : 0,
    name: 'RESULTADOS',
    url : '',
    children: [
      { 
        id : 0,
        name: 'INDICADORES',
        url : 'indicators'
      },
      { 
        id : 0,
        name: 'REPORTES',
        url : 'reports'
      }
    ],
  }
];
@Component({
  selector: 'app-root',
  standalone: true,
  imports: [QuillEditorComponent,CommonModule, MsalModule, RouterOutlet, RouterLink, MatToolbarModule, 
            MatButtonModule, MatMenuModule,MatIconModule,MatSidenavModule,MatRadioModule,
            FormsModule,ReactiveFormsModule,MatDividerModule,MatTreeModule,MatSnackBarModule],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent implements OnInit, OnDestroy {
  title = 'My Anddes Onboarding Admin';
  
  mdcBackdrop: BooleanInput = true;
  drawerMode: MatDrawerMode = "push";
  mode = new FormControl('over' as MatDrawerMode);

  
  readonly breakpoint$ = this.breakpointObserver
  .observe([ '(max-width: 500px)']);

  isIframe = false;
  loginDisplay = false;
  private readonly _destroying$ = new Subject<void>();

  treeControl = new NestedTreeControl<TreeNode>(node => node.children);
  dataSource = new MatTreeNestedDataSource<TreeNode>();

  treeControlReporte = new NestedTreeControl<TreeNode>(node => node.children);
  dataSourceReporte = new MatTreeNestedDataSource<TreeNode>();
  
  constructor(
    private breakpointObserver: BreakpointObserver,
    @Inject(MSAL_GUARD_CONFIG) private msalGuardConfig: MsalGuardConfiguration,
    private authService: MsalService,
    private msalBroadcastService: MsalBroadcastService,
    private authServiceAnddes: AuthService,
    private snackbarService : SnackbarService,
    private router :Router
  ){
    this.breakpoint$.subscribe(() =>
      this.breakpointChanges()
    );
    this.dataSource.data = TREE_DATA;
    this.treeControl.dataNodes=TREE_DATA;
    this.treeControl.expandAll()

    this.dataSourceReporte.data = TREE_DATA_REPORTES;
    this.treeControlReporte.dataNodes=TREE_DATA_REPORTES;
    this.treeControlReporte.expandAll()
  }
  userLogged: any
  ngOnInit(): void {
    this.authService.handleRedirectObservable().subscribe();
    
    //this.isIframe = false;//window !== window.parent && !window.opener; // Remove this line to use Angular Universal
    if (typeof window !== "undefined") {
      this.isIframe = window !== window.parent && !window.opener;
    }
    this.setLoginDisplay();

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
    
    if(this.loginDisplay){
      setTimeout(()=>{
          this.authServiceAnddes.getProfile().subscribe({
            next: value => {},
            error: err=> this.loginDisplay=false
          });
        },700)
    }
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

  loginRedirect() {
    if (this.msalGuardConfig.authRequest){
      this.authService.loginRedirect({...this.msalGuardConfig.authRequest} as RedirectRequest);
    } else {
      this.authService.loginRedirect();
    }
  }

  loginPopup() {
    if (this.msalGuardConfig.authRequest){
      this.authService.loginPopup({...this.msalGuardConfig.authRequest} as PopupRequest)
        .subscribe((response: AuthenticationResult) => {
          this.authService.instance.setActiveAccount(response.account);
        });
      } else {
        this.authService.loginPopup()
          .subscribe((response: AuthenticationResult) => {
            this.authService.instance.setActiveAccount(response.account);
      });
    }
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

  ngOnDestroy(): void {
    this._destroying$.next(undefined);
    this._destroying$.complete();
  }
  breakpointChanges(): void {
    if (this.breakpointObserver.isMatched('(max-width: 500px)')) {
      this.drawerMode = "over";
      this.mdcBackdrop = true;
    } else {
      this.drawerMode = "push";
      this.mdcBackdrop = false;
    }
  }
  hasChild = (_: number, node: TreeNode) => !!node.children && node.children.length > 0;
}
