package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class ToolDTO {
  private Long id;
  private String name;
  private String description;
  private String cover;
  private String link;
}
