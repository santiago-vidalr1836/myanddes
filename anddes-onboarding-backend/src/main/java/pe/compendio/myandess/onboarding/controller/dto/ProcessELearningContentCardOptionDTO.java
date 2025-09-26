package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class ProcessELearningContentCardOptionDTO {
  private Long id;
  private String description;
  private boolean correct;
  private boolean deleted;
  private boolean checked;
}
