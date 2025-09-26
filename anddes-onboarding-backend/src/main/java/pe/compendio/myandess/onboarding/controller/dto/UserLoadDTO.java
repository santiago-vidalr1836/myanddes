package pe.compendio.myandess.onboarding.controller.dto;

import com.fasterxml.jackson.annotation.JsonAlias;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserLoadDTO {
  @JsonAlias("Documento")
  private String dni;
  @JsonAlias("Empleado")
  private String fullname;
  @JsonAlias("Cargo")
  private String job;
  @JsonAlias("Jefe")
  private String bossFullname;
  @JsonAlias("correo")
  private String email;
}
