import { Component, OnInit } from '@angular/core';
import { SnackbarService } from '../../service/snackbar.service';

@Component({
  selector: 'app-login-failed',
  standalone: true,
  imports: [],
  templateUrl: './login-failed.component.html',
  styleUrl: './login-failed.component.scss'
})
export class LoginFailedComponent implements OnInit{
  constructor(private snackBarService:SnackbarService){

  }
  ngOnInit(): void {
    this.snackBarService.error('Fallo el login');
  }
}
