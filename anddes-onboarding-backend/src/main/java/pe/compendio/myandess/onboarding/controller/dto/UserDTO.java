package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class UserDTO {
  private Long id;
  private String dni;
  private String image;
  private String fullname;
  private String job;
  private UserDTO boss;
  private String email;
  private boolean onItinerary;
  private List<String> hobbies;
  private List<String> roles;
  private boolean admin;
  private String nickname;
}
