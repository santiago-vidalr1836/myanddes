package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class NotificationEmailTemplateDTO {
    private Long id;
    private String name;
    private String subject;
    private String bodyTemplate;
    private String additionalMessage;
    private String purpose;
}
