package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
public class ProcessActivityDTO {
  private Long id;
  private ActivityDTO activity;
  private boolean completed;
  private LocalDateTime completionDate;
}
