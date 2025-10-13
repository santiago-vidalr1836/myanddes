import { Routes } from '@angular/router';
import { MsalGuard} from '@azure/msal-angular';

export const routes: Routes = [
    /*{
        path: '',
        loadComponent:() => import('./components/auth/auth.component').then(mod => mod.AuthComponent),
        providers: [
        importProvidersFrom(
            MsalModule.forRoot(
                new PublicClientApplication({
                  auth: {
                    clientId: environment['microsoft-entra-client-id'], // Application (client) ID from the app registration
                    authority: environment['microsoft-entra-tenant-id'], // The Azure cloud instance and the app's sign-in audience (tenant ID, common, organizations, or consumers)
                    redirectUri: environment['microsoft-entra-return-url'] // This is your redirect URI
                  },
                  cache: {
                    cacheLocation: "localStorage",
                    storeAuthStateInCookie: false, // Set to true for Internet Explorer 11
                  },
                }),
                null,
                null
              )
          )
        ]
    },
    {
        path: 'auth',
        loadComponent:() => import('./components/auth/auth.component').then(mod => mod.AuthComponent),
        providers: [
        importProvidersFrom(
            MsalModule.forRoot(
                new PublicClientApplication({
                  auth: {
                    clientId: environment['microsoft-entra-client-id'], // Application (client) ID from the app registration
                    authority: environment['microsoft-entra-tenant-id'], // The Azure cloud instance and the app's sign-in audience (tenant ID, common, organizations, or consumers)
                    redirectUri: environment['microsoft-entra-return-url'] // This is your redirect URI
                  },
                  cache: {
                    cacheLocation: "localStorage",
                    storeAuthStateInCookie: false, // Set to true for Internet Explorer 11
                  },
                }),
                null,
                null
              )
        )
      ]
    },*/
    {
      path : '',
      loadComponent: () => import('./components/home/home.component').then(mod => mod.HomeComponent),
      //canActivate : [MsalGuard]
    },
    {
      path : 'home',
      loadComponent: () => import('./components/home/home.component').then(mod => mod.HomeComponent),
      //canActivate : [MsalGuard]
    },
    {
      path: 'users',
      loadComponent:() => import('./components/users/users.component').then(mod => mod.UsersComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'user/edit',
      loadComponent:() => import('./components/user-edit/user-edit.component').then(mod => mod.UserEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'tools',
      loadComponent:() => import('./components/tools/tools.component').then(mod => mod.ToolsComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'tool/modify',
      loadComponent:() => import('./components/tool-add-edit/tool-add-edit.component').then(mod => mod.ToolAddEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'services',
      loadComponent:() => import('./components/services/services.component').then(mod => mod.ServicesComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'service/edit',
      loadComponent:() => import('./components/service-edit/service-edit.component').then(mod => mod.ServiceEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'service/detail',
      loadComponent:() => import('./components/service-detail/service-detail.component').then(mod => mod.ServiceDetailComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'processes',
      loadComponent:() => import('./components/processes/processes.component').then(mod => mod.ProcessesComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'process/add',
      loadComponent:() => import('./components/process-add/process-add.component').then(mod => mod.ProcessAddComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'process/edit',
      loadComponent:() => import('./components/process-edit/process-edit.component').then(mod => mod.ProcessEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'before',
      loadComponent:() => import('./components/before/before.component').then(mod => mod.BeforeComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'first-day-information-item',
      loadComponent:() => import('./components/first-day-information-item-edit/first-day-information-item-edit.component').then(mod => mod.FirstDayInformationItemEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'first-day',
      loadComponent:() => import('./components/first-day/first-day.component').then(mod => mod.FirstDayComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'on-site-induction-edit',
      loadComponent:() => import('./components/on-site-induction-edit/on-site-induction-edit.component').then(mod => mod.OnSiteInductionEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'remote-induction-edit',
      loadComponent:() => import('./components/remote-induction-edit/remote-induction-edit.component').then(mod => mod.RemoteInductionEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'first-week',
      loadComponent:() => import('./components/first-week/first-week.component').then(mod => mod.FirstWeekComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'elearning-content/add',
      loadComponent:() => import('./components/elearning-content-add/elearning-content-add.component').then(mod => mod.ElearningContentAddComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'elearning-content/add/content',
      loadComponent:() => import('./components/elearning-content-edit/elearning-content-edit.component').then(mod => mod.ElearningContentEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'elearning-content/edit',
      loadComponent:() => import('./components/elearning-content-edit/elearning-content-edit.component').then(mod => mod.ElearningContentEditComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'indicators',
      loadComponent:() => import('./components/indicators/indicators.component').then(mod => mod.IndicatorsComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'notifications',
      loadComponent:() => import('./components/notifications/notifications.component').then(mod => mod.NotificationsComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'notifications/templates/edit',
      loadComponent:() => import('./components/notifications-email-template-form/notifications-email-template-form.component').then(mod => mod.NotificationsEmailTemplateFormComponent),
      canActivate : [MsalGuard]
    },
    {
      path: 'reports/general/:processId',
      loadComponent: () =>
        import('./components/reports/general-detail/general-detail.component').then(
          (mod) => mod.GeneralDetailComponent
        ),
      canActivate: [MsalGuard],
    },
    {
      path: 'reports/elearning/:processId',
      loadComponent: () =>
        import('./components/reports/elearning-detail/elearning-detail.component').then(
          (mod) => mod.ElearningDetailComponent
        ),
      canActivate: [MsalGuard],
    },
    {
      path: 'reports',
      loadComponent: () => import('./components/reports/reports.component').then(mod => mod.ReportsComponent),
      canActivate: [MsalGuard]
    },
    {
      path: 'login-failed',
      loadComponent: ()=> import('./components/login-failed/login-failed.component').then(mod => mod.LoginFailedComponent)
    }
];
