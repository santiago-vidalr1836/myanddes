import { Injectable } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable({
  providedIn: 'root'
})
export class SnackbarService {

  constructor(private _snackBar: MatSnackBar) {}

  error(message: string) {
    return this._snackBar.open(message, undefined, {panelClass: ['snackbar-error'],duration: 3 * 1000});
  }

  success(message: string) {
    return this._snackBar.open(message, undefined, {panelClass: ['snackbar-success'],duration: 3 * 1000});
  }

  info(message: string) {
    return this._snackBar.open(message, undefined, {panelClass: ['snackbar-info'],duration: 3 * 1000});
  }
}