package pe.compendio.myandess.onboarding.controller.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProcessPagedDTO {
  private int total;
  private List<ProcessDTO> processes;
}
