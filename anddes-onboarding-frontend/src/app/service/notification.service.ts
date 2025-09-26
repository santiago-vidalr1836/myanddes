import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../environments/environment';
import { NotificationEmailTemplate, NotificationSenderProfile } from '../entity/notification';

@Injectable({
  providedIn: 'root'
})
export class NotificationService {
  constructor(private httpClient: HttpClient) { }

  listNotificationSenderProfile() {
    var endpoint = environment.baseUrl + 'notification/profile'
    return this.httpClient.get<NotificationSenderProfile[]>(endpoint);
  }
  updateNotificationSenderProfile(notificationSenderProfile: NotificationSenderProfile) {
    var endpoint = environment.baseUrl + 'notification/profile/' + notificationSenderProfile.id;
    return this.httpClient.put(endpoint, notificationSenderProfile);
  }

  getEmailTemplate(templateId: number) {
    console.log(templateId);
    console.log(typeof templateId);
    var endpoint = environment.baseUrl + 'notification/templates/' + templateId
    return this.httpClient.get(endpoint);
  }
  updateEmailTemplate(notificationEmailTemplate: NotificationEmailTemplate) {
    var endpoint = environment.baseUrl + 'notification/templates/' + notificationEmailTemplate.id;
    return this.httpClient.put(endpoint, notificationEmailTemplate);
  }
}
