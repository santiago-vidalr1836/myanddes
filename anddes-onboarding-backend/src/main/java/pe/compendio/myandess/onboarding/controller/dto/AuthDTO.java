package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class AuthDTO {
  private Long id;
  private String email;
  private String fullname;
  private String givenName;
  private String familyName;
  private List<String> roles;
  private boolean onItinerary;
  private boolean admin;
  private String nickname;
  private String image;
  private List<String> hobbies;
}
