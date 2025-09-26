import { Component, OnInit } from '@angular/core';
import { NotificationEmailTemplate } from '../../entity/notification';
import { NotificationService } from '../../service/notification.service';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatMenuModule } from '@angular/material/menu';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { Location } from '@angular/common';
import { MatCardModule } from '@angular/material/card';
import { SnackbarService } from '../../service/snackbar.service';

@Component({
  selector: 'app-notifications-email-template-form',
  standalone: true,
  imports: [
    MatIconModule,
    MatButtonModule,
    MatMenuModule,
    MatFormFieldModule,
    MatCardModule,
    MatInputModule,
    FormsModule,
    ReactiveFormsModule
  ],
  templateUrl: './notifications-email-template-form.component.html',
  styleUrl: './notifications-email-template-form.component.scss'
})
export class NotificationsEmailTemplateFormComponent implements OnInit {

  emailTemplate: NotificationEmailTemplate = new NotificationEmailTemplate();

  constructor(
    private notificationService: NotificationService,
    private location : Location,
    private snackBarService: SnackbarService
  ) { }

  ngOnInit(): void {
    if (typeof window !== 'undefined') {
      var template = window.history.state
      this.notificationService.getEmailTemplate(template.id).subscribe((r: any) => {
        this.emailTemplate = r;
      })
    }
  }
  back() {
    this.location.back()
  }
  save(){
    this.notificationService.updateEmailTemplate(this.emailTemplate).subscribe((r:any)=>{
      this.snackBarService.success('Plantilla de correo actualizado')
      this.location.back()
    })
  }

}
