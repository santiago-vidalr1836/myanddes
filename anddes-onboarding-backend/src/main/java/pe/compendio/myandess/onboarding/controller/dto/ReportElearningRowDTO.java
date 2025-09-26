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
public class ReportElearningRowDTO {
  private Long processId;
  private String collaborator;
  private int totalCourses;
  private int completedCourses;
  private double progress;
  private long readCards;
  private long correctAnswers;
  private String state;
  private LocalDateTime finishDate;
}
