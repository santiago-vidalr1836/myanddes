package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.*;
import pe.compendio.myandess.onboarding.service.ActivityService;
import pe.compendio.myandess.onboarding.service.ProcessService;
import pe.compendio.myandess.onboarding.service.UserService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/onboarding")
public class OnBoardingController {
  @Autowired
  UserService userService;
  @Autowired
  ActivityService activityService;

  @Autowired
  ProcessService processService;
  @Autowired
  Mapper mapper;

  @Operation(summary = "Obtener el proceso de onboarding por id de usuario")
  @GetMapping("/{userId}/process/")
  public ProcessDTO getProcess(@PathVariable Long userId){
    return mapper.processEntityToDTO(processService.findByUserId(userId));
  }

  @Operation(summary = "Actualizar que para un proceso de onboarding se mostro la pantalla de bienvenida")
  @PutMapping("/{userId}/process/{processId}/welcomed")
  public ResponseEntity<?> updateProcess(@PathVariable Long processId){
    processService.updateWelcomed(processId);
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Listar las actividades de un proceso de onboarding")
  @GetMapping("/{userId}/process/{processId}/activities")
  public List<ProcessActivityDTO> getProcessActivity(@PathVariable Long processId){
    return mapper.processActivityEntitiesToDTOs(processService.findActivityByProcessId(processId));
  }

  @Operation(summary = "Actualizar las actividades completadas para un proceso de onboarding")
  @PutMapping("/{userId}/process/{processId}/activities")
  public ResponseEntity<?> updateCompletedActivities(@PathVariable Long processId, @RequestBody List<ProcessActivityDTO> activities){
    processService.updateCompletedActivities(mapper.processActivityDTOToEntities(activities));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Buscar actividad de un proceso de onboarding por id")
  @GetMapping("/{userId}/process/{processId}/activities/{activityId}")
  public ProcessActivityDTO findProcessActivityById(@PathVariable Long activityId){
    return mapper.processActivityEntityToDTO(processService.findActivityById(activityId));
  }

  @Operation(summary = "Actualizar actividad de un proceso de onboarding por id")
  @PutMapping("/{userId}/process/{processId}/activities/{activityId}")
  public ResponseEntity<?> updateCompletedActivities(@PathVariable Long activityId){
    processService.updateCompletedActivity(activityId);
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Obtener informacion para mostrar del proceso de onboarding")
  @GetMapping("/{userId}/process/{processId}/activities/detail")
  public OnboardingDTO getOnboarding(@PathVariable Long userId,@PathVariable Long processId){
    return OnboardingDTO.builder()
                        .team(mapper.userEntitiesToUserDTO(userService.findTeam_ByUserId(userId)))
                        .ceoPresentation(mapper.ceoPresentationEntityToDto(activityService.listCEOPresentation()))
                        .firstDayInformationItems(mapper.firstDayEntitiesToDTO(activityService.listFirstDayInformationItems()))
                        .onSiteInduction(mapper.onSiteInductionEntityToDto(activityService.findOnSiteInduction()))
                        .remoteInduction(mapper.remoteInductionEntityToDto(activityService.findRemoteInduction()))
                        .eLearningContents(mapper.eLearningContentEntitiesToDtos(activityService.listELearningContent()))
                        .build();
  }

  @Operation(summary = "Obtener el Contenido Elearning de un proceso")
  @GetMapping("/{userId}/process/{processId}/activities/{processActivityId}/content")
  public ProcessActivityContentDTO getProcessActivityContent(@PathVariable Long processId,@PathVariable Long processActivityId,@RequestParam(name = "eLearningContentId") Long eLearningContentId){
    return mapper.processActivityContentEntityToDTO(processService.findProcessActivityContentByElearningId(processActivityId,eLearningContentId));
  }
  @Operation(summary = "Crear el Contenido Elearning de un proceso")
  @PostMapping("/{userId}/process/{processId}/activities/{processActivityId}/content")
  public ResponseEntity<?> createNewProcessActivityContent(@PathVariable Long processId,@PathVariable Long processActivityId,@RequestParam(name = "eLearningContentId") Long eLearningContentId){
    processService.createNewProcessActivityContent(processActivityId,eLearningContentId);
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Actualizar que una tarjeta ha sido revisada")
  @PutMapping("/{userId}/process/{processId}/activities/{processActivityId}/content/{processActivityContentId}/card/{processActivityContentCardId}")
  public ResponseEntity<?> updateReadAndAnswer(@PathVariable Long processActivityContentCardId,@RequestBody ProcessActivityContentCardAnswerDTO answer){
    processService.updateReadAndAnswer(processActivityContentCardId,answer);
    return ResponseEntity.ok().build();
  }
  @Operation(summary = "Calcular el resultado de un curso de elearning")
  @PostMapping("/{userId}/process/{processId}/activities/{processActivityId}/content/{processActivityContentId}/result")
  public ELearningResultDTO calculateResult(@PathVariable Long processId,@PathVariable Long processActivityContentId){
    return ELearningResultDTO.builder()
          .result(processService.calculateResult(processActivityContentId))
          .build();
  }
}
