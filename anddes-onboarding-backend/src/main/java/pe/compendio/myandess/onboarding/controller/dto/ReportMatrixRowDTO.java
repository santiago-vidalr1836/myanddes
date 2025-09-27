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
  private LocalDateTime elearningFinishDate;
  private double generalProgress;
  private int generalCompletedActivities;
  private int generalTotalActivities;
  private String generalState;
  private String processState;
  private double elearningProgress;
  private int elearningCompletedContents;
  private int elearningTotalContents;
  private String elearningState;
  private Map<String, String> elearningResults;
}
