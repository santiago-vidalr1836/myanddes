package pe.compendio.myandess.onboarding.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportMatrixRowDTO {
  private Long processId;
  private String dni;
  private String fullName;
  private LocalDate startDate;
  private LocalDateTime finishDate;
  private double generalProgress;
  private String processState;
  private double elearningProgress;
  private Map<String, ReportMatrixELearningResultDTO> elearningResults;
  private boolean delayed;
}
