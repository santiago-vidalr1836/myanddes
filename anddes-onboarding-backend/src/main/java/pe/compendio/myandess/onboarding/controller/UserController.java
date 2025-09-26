package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.LoadResponse;
import pe.compendio.myandess.onboarding.controller.dto.UserEditDTO;
import pe.compendio.myandess.onboarding.controller.dto.UserLoadDTO;
import pe.compendio.myandess.onboarding.controller.dto.UserPagedDTO;
import pe.compendio.myandess.onboarding.service.UserService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/users")
public class UserController {
  @Autowired
  UserService userService;
  @Autowired
  Mapper mapper;

  @Operation(summary = "Listar paginas de los usuarios del sistema")
  @GetMapping
  public UserPagedDTO listAll(@RequestParam(defaultValue = "") String filter,
                              @RequestParam(defaultValue = "0") Integer page,
                              @RequestParam(defaultValue = "100") Integer pageSize,
                              @RequestParam(defaultValue = "fullname") String orderBy,
                              @RequestParam(defaultValue = "asc") String direction){
    var userPage=userService.findByFilter(filter,page,pageSize,orderBy,direction);
    return UserPagedDTO
          .builder()
          .total(Math.toIntExact(userPage.getTotalElements()))
          .users(mapper.userEntitiesToUserDTO(userPage.getContent()))
          .build();
  }

  @Operation(summary = "Actualizar un usuario")
  @PutMapping("/{userId}")
  public ResponseEntity<?> update(@PathVariable Long userId,@RequestBody UserEditDTO dto){
    dto.setId(userId);
    userService.update(mapper.dtoToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Cargar usuarios mediante un excel")
  @PostMapping("/load")
  public LoadResponse load(@RequestBody List<UserLoadDTO> dtos){
    var array=userService.load(mapper.loadDtosToUserEntities(dtos));
    return LoadResponse
            .builder()
            .newUsers(mapper.userEntitiesToUserDTO(array[0]))
            .modifiedUsers(mapper.userEntitiesToUserDTO(array[1]))
            .errors(mapper.userEntitiesToUserDTO(array[2]))
            .build();
  }

  @Operation(summary = "Eliminar un usuario")
  @DeleteMapping("/{userId}")
  public ResponseEntity<?> delete(@PathVariable Long userId){
    userService.delete(userId);
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Listar los usuarios por filtro de si estan asignados a un itinerario")
  @GetMapping("/onItinerary/{onIntinerary}")
  public UserPagedDTO listBy(@PathVariable String onIntinerary,
                              @RequestParam(defaultValue = "") String filter,
                              @RequestParam(defaultValue = "0") Integer page,
                              @RequestParam(defaultValue = "100") Integer pageSize,
                              @RequestParam(defaultValue = "fullname") String orderBy,
                              @RequestParam(defaultValue = "asc") String direction){
    var userPage=userService.findByOnItineraryAndFilter(Boolean.getBoolean(onIntinerary),filter,page,pageSize,orderBy,direction);
    return UserPagedDTO
      .builder()
      .total(Math.toIntExact(userPage.getTotalElements()))
      .users(mapper.userEntitiesToUserDTO(userPage.getContent()))
      .build();
  }
}
