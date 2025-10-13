package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.util.List;

@Data
public class ELearningContentDTO {
  private Long id;
  private String name;
  private String image;
  private List<ELearningContentCardDTO> cards;
  private Integer passingScore;
  private Integer position;
}
