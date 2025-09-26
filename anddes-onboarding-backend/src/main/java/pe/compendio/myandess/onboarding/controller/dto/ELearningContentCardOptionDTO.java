package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class ELearningContentCardOptionDTO {
  private Long id;
  private String description;
  private boolean correct;
  private boolean deleted;
}
