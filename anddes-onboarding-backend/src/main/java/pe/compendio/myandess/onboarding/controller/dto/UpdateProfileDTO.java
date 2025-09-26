package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;

import java.util.List;

@Data
public class UpdateProfileDTO {
  private Long userId;
  private String nickname;
  private String image;
  private List<String> hobbies;
}
