package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class NotificationSenderProfileDTO {
    private Long id;
    private String fullname;
    private String position;
    private String address;
    private String urlPhoto;
    private Integer remindersNumber;
}
