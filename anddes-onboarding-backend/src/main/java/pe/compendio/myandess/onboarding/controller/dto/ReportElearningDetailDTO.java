package pe.compendio.myandess.onboarding.controller.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportElearningDetailDTO {
  private Long contentId;
  private String courseName;
  private Integer result;
  private Integer minimumScore;
  private Integer attempts;
  private Integer progress;
  private int readCards;
  private int correctAnswers;
  private String state;
}
