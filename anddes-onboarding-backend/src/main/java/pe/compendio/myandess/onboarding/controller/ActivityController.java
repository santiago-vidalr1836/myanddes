package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.*;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.service.ActivityService;
import pe.compendio.myandess.onboarding.service.UserService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/activities")
public class ActivityController {
  @Autowired
  Mapper mapper;
  @Autowired
  ActivityService activityService;
  @Autowired
  UserService userService;

  @Operation(summary = "Listar las actividades del proceso de onboarding")
  @GetMapping
  public List<ActivityDTO> list(){
    return mapper.activityEntitiesToDTO(activityService.list());
  }

  @Operation(summary = "Listar las actividades del proceso de onboarding por filtro de codigo padre como Antes,Primer Dia o Primera Semana")
  @GetMapping("/parent/{parentCode}")
  public List<ActivityDTO> listByParentCode(@PathVariable String parentCode){
    return mapper.activityEntitiesToDTO(activityService.listByParentCode(parentCode));
  }

  @Operation(summary = "Obtener la actividad de tipo Presentacion Gerente General")
  @GetMapping("/code/"+Constants.ACTIVITY_CEO_PRESENTATION)
  public CEOPresentationDTO listCEOPresentation(){
    return mapper.ceoPresentationEntityToDto(activityService.listCEOPresentation());
  }

  @Operation(summary = "Actualizar la actividad de tipo Presentacion Gerente General")
  @PutMapping("/code/"+Constants.ACTIVITY_CEO_PRESENTATION+"/{idCEOPresentation}")
  public ResponseEntity<?> updateCEOPresentation(@PathVariable Long idCEOPresentation,
                                                 @RequestBody CEOPresentationDTO dto){
    dto.setId(idCEOPresentation);
    activityService.updateCEOPresentation(mapper.ceoPresentationDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Obtener los items de informacion para tu primer dia")
  @GetMapping("/code/"+Constants.ACTIVITY_FIRST_DAY_INFORMATION)
  public List<FirstDayInformationItemDTO> listFirstDayInformationItems(){
    return mapper.firstDayEntitiesToDTO(activityService.listFirstDayInformationItems());
  }

  @Operation(summary = "Actualizar los items de informacion para tu primer dia")
  @PutMapping("/code/"+Constants.ACTIVITY_FIRST_DAY_INFORMATION+"/{firstdayinformationitemId}")
  public ResponseEntity<?> updateFirstDayInformationItems(@PathVariable Long firstdayinformationitemId,
                                                          @RequestBody FirstDayInformationItemDTO dto){
    dto.setId(firstdayinformationitemId);
    activityService.updateFirstDayInformationItem(mapper.firstDayDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Obtener la actividad Induccion Presencial GT")
  @GetMapping("/code/"+Constants.ACTIVITY_ON_SITE_INDUCTION)
  public OnSiteInductionDTO listOnSiteInduction(){
    return mapper.onSiteInductionEntityToDto(activityService.findOnSiteInduction());
  }

  @Operation(summary = "Actualizar la actividad Induccion Presencial GT")
  @PutMapping("/code/"+Constants.ACTIVITY_ON_SITE_INDUCTION+"/{onSiteInductionId}")
  public ResponseEntity<?> updateOnSiteInduction(@PathVariable Long onSiteInductionId,
                                                 @RequestBody OnSiteInductionDTO dto){
    dto.setId(onSiteInductionId);
    activityService.updateOnSiteInduction(mapper.onSiteInductionDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Obtener la actividad Inducción virtual SSA")
  @GetMapping("/code/"+Constants.ACTIVITY_REMOTE_INDUCTION)
  public RemoteInductionDTO listRemoteInduction(){
    return mapper.remoteInductionEntityToDto(activityService.findRemoteInduction());
  }

  @Operation(summary = "Actualizar la actividad Inducción virtual SSA")
  @PutMapping("/code/"+Constants.ACTIVITY_REMOTE_INDUCTION+"/{remoteInductionId}")
  public ResponseEntity<?> updateRemoteInduction(@PathVariable Long remoteInductionId,
                                                 @RequestBody RemoteInductionDTO dto){
    dto.setId(remoteInductionId);
    activityService.updateRemoteInduction(mapper.remoteInductionDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Listar los cursos de Induccion Elearning")
  @GetMapping("/code/"+Constants.ACTIVITY_INDUCTION_ELEARNING)
  public List<ELearningContentDTO> listELearningContent(){
    return mapper.eLearningContentEntitiesToDtos(activityService.listELearningContent());
  }

  @Operation(summary = "Actualizar curso de Induccion Elearning")
  @PutMapping("/code/"+Constants.ACTIVITY_INDUCTION_ELEARNING+"/{eLearningContentId}")
  public ResponseEntity<?> updateELearningContent(@PathVariable Long eLearningContentId,
                                                  @RequestBody ELearningContentDTO dto){
    dto.setId(eLearningContentId);
    activityService.updateELearningContent(mapper.eLearningContentDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Listar los miembros del equipo")
  @GetMapping("/code/"+Constants.ACTIVITY_KNOW_YOUR_TEAM+"/{userId}")
  public List<UserDTO> listTeamMembers(@PathVariable Long userId){
    return mapper.userEntitiesToUserDTO(userService.findTeam_ByUserId(userId));
  }
}
