package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
public class ServiceDetailDTO {
  private Long id;
  private String title;
  private String description;
  private boolean hidden;
  private String icon;
}
