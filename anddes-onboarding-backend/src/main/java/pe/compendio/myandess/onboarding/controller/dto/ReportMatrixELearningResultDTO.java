package pe.compendio.myandess.onboarding.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportMatrixELearningResultDTO {
    private Double result;
    private Boolean approved;
}
