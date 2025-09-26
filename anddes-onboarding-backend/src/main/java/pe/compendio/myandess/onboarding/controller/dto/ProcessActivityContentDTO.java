package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.util.List;

@Data
public class ProcessActivityContentDTO {
  private Long id;
  private ELearningContentDTO content;
  private Double result;
  private Double progress;
  private List<ProcessActivityContentCardDTO> cards;
}
