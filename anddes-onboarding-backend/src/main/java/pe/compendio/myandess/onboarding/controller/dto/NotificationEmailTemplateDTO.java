package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class NotificationEmailTemplateDTO {
    private String id;
    private String name;
    private String subject;
    private String bodyTemplate;
    private String additionalMessage;
}
