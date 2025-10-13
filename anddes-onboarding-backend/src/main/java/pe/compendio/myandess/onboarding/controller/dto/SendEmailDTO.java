package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class SendEmailDTO {
    private String to;
    private String subject;
    private String body;
}
