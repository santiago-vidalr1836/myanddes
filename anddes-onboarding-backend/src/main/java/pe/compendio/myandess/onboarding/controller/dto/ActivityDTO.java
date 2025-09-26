package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

@Data
public class ActivityDTO {
  private Long id;
  private String code;
  private String name;
  private String parent;
  private String parentCode;
  private boolean editableInWeb;
  private boolean mandatory;
  private boolean manual;
}
