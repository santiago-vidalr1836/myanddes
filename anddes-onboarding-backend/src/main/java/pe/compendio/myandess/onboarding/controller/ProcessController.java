package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.*;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.service.ProcessService;
import pe.compendio.myandess.onboarding.util.DateUtil;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping(path = "/processes")
public class ProcessController {
  @Autowired
  Mapper mapper;
  @Autowired
  ProcessService processService;

  @Operation(summary = "Listar los procesos creados por paginas")
  @GetMapping
  public ProcessPagedDTO listPaged(@RequestParam(defaultValue = "0") Integer page,
                               @RequestParam(defaultValue = "100") Integer pageSize,
                               @RequestParam(defaultValue = "user.fullname") String orderBy,
                               @RequestParam(defaultValue = "asc") String direction){
    var processPage=processService.list(page,pageSize,orderBy,direction);
    return ProcessPagedDTO
      .builder()
      .total(Math.toIntExact(processPage.getTotalElements()))
      .processes(mapper.processEntityToDTO(processPage.getContent()))
      .build();
  }

  @Operation(summary = "Agregar un nuevo proceso de onboarding")
  @PostMapping
  public ResponseEntity<?> add(@RequestBody ProcessAddDTO dto){
    processService.add(mapper.processAddDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Actualizar un proceso de onboarding")
  @PutMapping("/{processId}")
  public ResponseEntity<?> update(@PathVariable Long processId,@RequestBody ProcessDTO dto){
    dto.setId(processId);
    processService.update(mapper.processDTOToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Listar las actividades de un proceso")
  @GetMapping("/{processId}/activities")
  public List<ProcessActivityDTO> listActivities(@PathVariable Long processId){
    return mapper.processActivityEntitiesToDTOs(processService.listActivities(processId));
  }

  @Operation(summary = "Cambiar el flag de completado a una actividad de un proceso")
  @PutMapping("/{processId}/activities/{activityId}")
  public  ResponseEntity<?> changeCompleteActivity(@PathVariable Long activityId,
                                             @RequestBody ProcessActivityCompleteDTO dto){
    processService.changeCompleteActivity(activityId,dto.isCompleted());
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Obtener los indicadores")
  @GetMapping("/indicators")
  public IndicatorsDTO getIndicators(@RequestParam String startDate,
                                     @RequestParam String endDate){
    LocalDate lStartDate= LocalDate.parse(startDate.substring(0,10));
    LocalDate lEndDate= LocalDate.parse(endDate.substring(0,10));

    List<Integer> indicatorOfElearning = processService.findIndicatorProcessInductionELearningFinished(lStartDate,lEndDate);
    return IndicatorsDTO
          .builder()
          .totalProcesses(processService.countProcessTotal(lStartDate,lEndDate))
          .completedProcesses(processService.countProcessComplete(lStartDate,lEndDate))
          .delayedProcesses(processService.countProcessDelayedAndNotFinished(lStartDate,lEndDate))
          .completedELearning(indicatorOfElearning.get(0))
          .averageELearningCompleted(indicatorOfElearning.get(1))
          .build();
  }

  @Operation(summary = "Descargar  excel con los procesos finalizados")
  @GetMapping("/download/finished")
  public ResponseEntity<byte[]> downloadProcessFinished() throws IOException {
    ByteArrayOutputStream stream =processService.downloadProcessFinished();

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

    ContentDisposition contentDisposition= ContentDisposition
      .attachment()
      .filename("processFinished"+ DateUtil.getCurrentDate_yyyyMMdd_hhmm()+".xlsx")
      .build();
    headers.setContentDisposition(contentDisposition);

    return ResponseEntity.ok()
      .headers(headers)
      .body(stream.toByteArray());
  }

  @Operation(summary = "Descargar  excel con las respuestas de los cursos de elearning")
  @GetMapping("/download/"+ Constants.ACTIVITY_INDUCTION_ELEARNING+"/answers")
  public ResponseEntity<byte[]> downloadProcessAnswers() throws IOException {
    ByteArrayOutputStream stream =processService.downloadProcessAnswers();

    HttpHeaders headers = new HttpHeaders();
    headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

    ContentDisposition contentDisposition= ContentDisposition
      .attachment()
      .filename("respuestas_elearning_"+ DateUtil.getCurrentDate_yyyyMMdd_hhmm()+".xlsx")
      .build();
    headers.setContentDisposition(contentDisposition);

    return ResponseEntity.ok()
      .headers(headers)
      .body(stream.toByteArray());
  }
}
