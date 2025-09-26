package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Data
public class ProcessELearningContentCardDTO {
  private Long id;
  private String title;
  private String type;
  private boolean draft;
  private String content;
  private boolean deleted;
  private Integer position;
  private boolean read;
  private LocalDateTime dateRead;
  private List<ProcessELearningContentCardOptionDTO> options;
  private String urlVideo;
  private String posterVideo;
}
