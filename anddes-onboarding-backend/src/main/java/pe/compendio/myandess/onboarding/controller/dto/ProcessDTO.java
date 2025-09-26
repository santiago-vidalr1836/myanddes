package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
public class ProcessDTO {
  private Long id;
  private UserDTO user;
  private LocalDate startDate;
  private Integer status;
  private List<String> results;

  private boolean finished;
  private boolean delayed;
  private boolean welcomed;
  private String hourOnsite;
  private String placeOnsite;
  private String hourRemote;
  private String linkRemote;
}
