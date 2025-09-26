package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.AuthDTO;
import pe.compendio.myandess.onboarding.controller.dto.UpdateProfileDTO;
import pe.compendio.myandess.onboarding.controller.dto.UserDTO;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.entity.User;
import pe.compendio.myandess.onboarding.service.UserService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.Objects;

@RestController
@RequestMapping(path = "/profile")
@Slf4j
public class ProfileController {
  @Autowired
  UserService userService;
  @Autowired
  Mapper mapper;

  @Operation(summary = "Obtener los datos de un token de azure")
  @GetMapping
  public ResponseEntity<AuthDTO> auth(@RequestParam(name = "source",defaultValue = "MOBILE") String source) {
    JwtAuthenticationToken authenticationToken = (JwtAuthenticationToken) SecurityContextHolder.getContext().getAuthentication();
    Jwt jwt = (Jwt) authenticationToken.getCredentials();

    String email = (String) jwt.getClaims().get("email");
    log.info("profile email={}",email);
    if(Objects.isNull(email)){
      email = (String) jwt.getClaims().get("unique_name");
      log.info("profile unique_name={}",email);
    }
    UserDTO user=mapper.userEntityToDTO(userService.findUserByEmail(email));

    if(Objects.isNull(user))
      return ResponseEntity.notFound().build();

    if(source.equals(Constants.SOURCE_WEB) && !user.isAdmin())
      return ResponseEntity.status(HttpStatus.FORBIDDEN).build();

    return ResponseEntity.ok().body(AuthDTO
      .builder()
      .id(user.getId())
      .givenName((String) jwt.getClaims().get("name"))
      //.familyName((String) jwt.getClaims().get("family_name"))
      .email(email)
      .onItinerary(user.isOnItinerary())
      .roles(user.getRoles())
      .admin(user.isAdmin())
      .nickname(user.getNickname())
      .image(user.getImage())
      .hobbies(user.getHobbies())
      .fullname(user.getFullname())
      .build());
  }

  @Operation(summary = "Actualizar el perfil de un usuario")
  @PutMapping
  public ResponseEntity<?> updateProfile(@RequestBody UpdateProfileDTO dto){
    var user = new User();
    user.setId(dto.getUserId());
    user.setImage(dto.getImage());
    user.setHobbies(dto.getHobbies());
    user.setNickname(dto.getNickname());

    userService.updateProfile(user);

    return ResponseEntity.ok().build();
  }
}
