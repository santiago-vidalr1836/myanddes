export class NotificationSenderProfile {
    id: number;
    fullname: string;
    position: string;
    address: string;
    urlPhoto: string;
}

export class NotificationEmailTemplate {
    id: number;
    name: string;
    subject: string;
    bodyTemplate: string;
    additionalMessage: string;
    purpose: string;
}