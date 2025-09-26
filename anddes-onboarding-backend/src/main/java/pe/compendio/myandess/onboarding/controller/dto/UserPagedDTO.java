package pe.compendio.myandess.onboarding.controller.dto;

import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPagedDTO {
  private int total;
  private List<UserDTO> users;
}
