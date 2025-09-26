package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;
import lombok.ToString;

import java.util.List;

@Data
@ToString
public class ProcessELearningContentDTO {
  private Long id;
  private String name;
  private String image;
  private boolean started;
  private Integer progress;
  private Integer result;
  private boolean finished;
  private List<ProcessELearningContentCardDTO> cards;
}
