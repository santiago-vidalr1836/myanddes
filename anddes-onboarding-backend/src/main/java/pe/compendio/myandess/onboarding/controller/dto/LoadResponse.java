package pe.compendio.myandess.onboarding.controller.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LoadResponse {
  private List<UserDTO> newUsers;
  private List<UserDTO> modifiedUsers;
  private List<UserDTO> errors;
}
