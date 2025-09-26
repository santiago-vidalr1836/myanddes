import { Routes } from '@angular/router';
import { WelcomeUserComponent } from './components/welcome-user/welcome-user.component';

export const routes: Routes = [
    {
        path: '',
        loadComponent: () => import('./components/home/home.component').then(mod => mod.HomeComponent),
    },
    {
        path: 'home',
        loadComponent: () => import('./components/home/home.component').then(mod => mod.HomeComponent),
    },
    {
        path: 'tools',
        loadComponent: () => import('./components/tools/tools.component').then(mod => mod.ToolsComponent),
    },
    {
        path: 'services',
        loadComponent: () => import('./components/services/services.component').then(mod => mod.ServicesComponent)
    },
    {
        path: 'activity-list',
        loadComponent: () => import('./components/activity-list/activity-list.component').then(mod => mod.ActivityListComponent)
    },
    {
        path: 'welcome-user',
        loadComponent: () => import('./components/welcome-user/welcome-user.component').then(mod => mod.WelcomeUserComponent)
    },
    {
        path: 'profile-edit',
        loadComponent: () => import('./components/profile-edit/profile-edit.component').then(mod => mod.ProfileEditComponent)
    },
    {
        path: 'first-day-information-item',
        loadComponent: () => import('./components/first-day-information/first-day-information.component').then(mod => mod.FirstDayInformationComponent)
    },
    {
        path: 'know-your-team',
        loadComponent: () => import('./components/know-your-team/know-your-team.component').then(mod => mod.KnowYourTeamComponent)
    },
    {
        path: 'onsite-induction',
        loadComponent: () => import('./components/onsite-induction/onsite-induction.component').then(mod => mod.OnsiteInductionComponent)
    },
    {
        path: 'remote-induction',
        loadComponent: () => import('./components/remote-induction/remote-induction.component').then(mod => mod.RemoteInductionComponent)
    },
    {
        path: 'elearning-contents',
        loadComponent: () => import('./components/elearning-content/elearning-content.component').then(mod => mod.ElearningContentComponent)
    }
];
