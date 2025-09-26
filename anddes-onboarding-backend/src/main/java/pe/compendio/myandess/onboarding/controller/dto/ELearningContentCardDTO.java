package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.util.List;

@Data
public class ELearningContentCardDTO {
  private Long id;
  private String title;
  private String type;
  private boolean draft;
  private String content;
  private boolean deleted;
  private Integer position;
  private List<ELearningContentCardOptionDTO> options;
  private String urlVideo;
  private String urlPoster;

}
