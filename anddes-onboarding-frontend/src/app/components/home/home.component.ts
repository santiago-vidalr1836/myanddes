import { AfterViewInit, Component, OnInit } from '@angular/core';
import { AuthService } from '../../service/auth.service';
import { Router } from '@angular/router';
import { MsalService } from '@azure/msal-angular';
import { SnackbarService } from '../../service/snackbar.service';


@Component({
  selector: 'app-home',
  standalone: true,
  imports: [],
  providers: [SnackbarService],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent implements AfterViewInit{
  constructor(private authService : AuthService,
              private msalService : MsalService,
              private router : Router,
              private snackbarService : SnackbarService
  ){}
  ngAfterViewInit(): void {
    this.authService.getProfile().subscribe({
      next: value => this.onSuccess(value),
      error: err=> this.onError(err)
    });
  }
  onSuccess(value){
    console.log(value)
    //localStorage.setItem('_profile_value', JSON.stringify(value));
    this.router.navigate(['/users']);
  }
  onError(err){
    console.log(err)
    this.snackbarService.error('No tiene acceso a la aplicacion.')
  }
}
