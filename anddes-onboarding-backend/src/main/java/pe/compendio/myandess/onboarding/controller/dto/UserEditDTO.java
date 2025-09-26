package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class UserEditDTO {
  private Long id;
  private String fullname;
  private String job;
  private Long bossId;
  private String image;
  private String email;
  private List<String> roles;
}
