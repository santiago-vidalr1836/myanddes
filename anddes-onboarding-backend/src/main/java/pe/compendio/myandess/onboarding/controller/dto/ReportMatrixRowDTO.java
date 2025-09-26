package pe.compendio.myandess.onboarding.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportMatrixRowDTO {
  private Long processId;
  private String collaborator;
  private LocalDate startDate;
  private LocalDateTime finishDate;
  private double generalProgress;
  private String generalState;
  private double elearningProgress;
  private String elearningState;
}
