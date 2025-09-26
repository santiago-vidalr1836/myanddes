package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ProcessActivityContentCardDTO {
  private Long id;
  private ELearningContentCardDTO card;
  private ELearningContentCardOptionDTO answer;
  private LocalDateTime readDateMobile;
  private LocalDateTime readDateServer;
}
