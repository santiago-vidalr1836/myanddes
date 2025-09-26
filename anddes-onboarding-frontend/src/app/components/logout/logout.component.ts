import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { MsalService } from '@azure/msal-angular';

@Component({
  selector: 'app-logout',
  standalone: true,
  imports: [],
  templateUrl: './logout.component.html',
  styleUrl: './logout.component.scss'
})
export class LogoutComponent implements OnInit{
  constructor(private authService: MsalService,
    private router: Router,){

  }
  ngOnInit(): void {
    this.authService.logout();
    this.router.navigate(['/']);
  }
}
