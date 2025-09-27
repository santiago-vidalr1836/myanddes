package pe.compendio.myandess.onboarding.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportActivityDetailDTO {
  private Long activityId;
  private String activityName;
  private boolean completed;
  private LocalDateTime completionDate;
  private String state;
  private String parentCode;
}
