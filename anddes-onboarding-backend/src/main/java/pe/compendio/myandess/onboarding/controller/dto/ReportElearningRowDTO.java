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
public class ReportElearningRowDTO {
  private Long processId;
  private String dni;
  private String fullName;
  private LocalDate startDate;
  private LocalDateTime finishDate;
  private double progress;
  private String state;
}
