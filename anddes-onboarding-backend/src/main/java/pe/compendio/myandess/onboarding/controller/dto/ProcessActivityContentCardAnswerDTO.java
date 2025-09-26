package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@ToString
public class ProcessActivityContentCardAnswerDTO {
  private LocalDateTime readDateMobile;
  private ELearningContentCardOptionDTO answer;
}
