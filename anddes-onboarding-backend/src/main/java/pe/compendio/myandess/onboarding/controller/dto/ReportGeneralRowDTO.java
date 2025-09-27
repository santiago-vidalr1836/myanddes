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
public class ReportGeneralRowDTO {
  private Long processId;
  private String fullName;
  private String dni;
  private boolean delayed;
  private LocalDate startDate;
  private LocalDateTime finishDate;
  private int totalActivities;
  private int completedActivities;
  private double progress;
  private String state;
}
