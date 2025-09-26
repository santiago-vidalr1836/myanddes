package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class FirstDayInformationItemDTO {
  private Long id;
  private String title;
  private String description;
  private String body;
  private boolean addFromServices;
  private String type;
  private String icon;
  private String iconWeb;
}
