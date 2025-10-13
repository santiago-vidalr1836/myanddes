export class NotificationSenderProfile {
    id: number;
    fullname: string;
    position: string;
    address: string;
    urlPhoto: string;
    remindersNumber: number;
}

export class NotificationEmailTemplate {
    id: string;
    name: string;
    subject: string;
    bodyTemplate: string;
    additionalMessage: string;
    purpose: string;
}