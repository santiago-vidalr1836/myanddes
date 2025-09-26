package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.compendio.myandess.onboarding.controller.dto.EmailDTO;
import pe.compendio.myandess.onboarding.service.UserService;

@RestController
@RequestMapping(path = "/me")
public class MeController {
  @Autowired
  UserService userService;

  @Operation(summary = "Validar si existe un usuario por correo electronico")
  @PostMapping("/validate")
  public ResponseEntity<?> email(@RequestBody EmailDTO dto) {
    if(userService.existUserWithEmail(dto.getEmail()))
      return  ResponseEntity.ok().build();
    else return  ResponseEntity.notFound().build();
  }
  /*@GetMapping("/me/isAdmin")
  public ResponseEntity<String> isAdmin(@RequestBody EmailDTO dto) {
    if(userService.hasRole(dto.getEmail()))
      return  ResponseEntity.ok().build();
    else return  ResponseEntity.notFound().build();
  }*/
}
