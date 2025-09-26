package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class IndicatorsDTO {
  private Integer totalProcesses;
  private Integer completedProcesses;
  private Integer delayedProcesses;

  private Integer completedELearning;
  private Integer averageELearningCompleted;
}
