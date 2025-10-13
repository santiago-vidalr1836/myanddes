import { Component, OnInit } from '@angular/core';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { FileService } from '../../service/file.service';
import { MatIconModule } from '@angular/material/icon';
import { NotificationSenderProfile } from '../../entity/notification';
import { NotificationService } from '../../service/notification.service';
import { SnackbarService } from '../../service/snackbar.service';
import { MatListModule } from '@angular/material/list';
import { Router } from '@angular/router';

@Component({
  selector: 'app-notifications',
  standalone: true,
  imports: [
    MatIconModule,
    MatCardModule,
    MatButtonModule,
    MatFormFieldModule,
    MatInputModule,
    FormsModule,
    MatListModule,
    ReactiveFormsModule],
  templateUrl: './notifications.component.html',
  styleUrl: './notifications.component.scss'
})
export class NotificationsComponent implements OnInit {

  acceptedFiles = 'image/*';
  notificationSenderProfile: NotificationSenderProfile = new NotificationSenderProfile();
  disableButton = true;

  constructor(
    private fileService: FileService,
    private notificationService: NotificationService,
    private snackBarService: SnackbarService,
    private router: Router
  ) { 
  }

  ngOnInit(): void {
    this.notificationService.listNotificationSenderProfile().subscribe(r => {
      if(r[0]){
        this.notificationSenderProfile = r[0];
      }
    })
  }

  save() {
    console.log(this.notificationSenderProfile);
    this.notificationService.updateNotificationSenderProfile(this.notificationSenderProfile).subscribe(r => {
      this.snackBarService.success('configuración general actualizada')
    })
  }
  onFileSelected(event) {
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      const file = (event.target as HTMLInputElement).files[0];
      this.fileService.upload(file).subscribe((r: any) => this.notificationSenderProfile.urlPhoto = r.url);
      (event.target as HTMLInputElement).value = null
    }
  }
  getFileNameFromUrl(url: string) {
    return url.split('/').pop();
  }
  onInputChange(event: Event) {
    this.disableButton = false;
  }
  editTemplate(templateId: string) {
    var template = { id: templateId };
    this.router.navigate(['notifications/templates/edit'], { state: template });
  }
}
