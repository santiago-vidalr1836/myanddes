package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.ServiceDTO;
import pe.compendio.myandess.onboarding.controller.dto.ServiceDetailDTO;
import pe.compendio.myandess.onboarding.service.ServiceService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/services")
public class ServiceController {
    @Autowired
    ServiceService serviceService;
    @Autowired
    Mapper mapper;

  @Operation(summary = "Listar los servicios que se muestran en vida en la empresa")
  @GetMapping
  public List<ServiceDTO> list(){
    return mapper.entitiesToDto(serviceService.list());
  }

  @Operation(summary = "Actualizar un servicio que se muestran en vida en la empresa")
  @PutMapping("/{serviceId}")
  public ResponseEntity<?> update(@PathVariable Long serviceId, @RequestBody ServiceDTO dto){
    dto.setId(serviceId);
    serviceService.update(mapper.dtoToEntity(dto));
    return ResponseEntity.ok().build();
  }
  
  @Operation(summary = "Obtener los detalles de un servicio que se muestra en vida en la empresa")
  @PutMapping("/{serviceId}/details")
  public ResponseEntity<?> updateDetail(@PathVariable Long serviceId, @RequestBody List<ServiceDetailDTO> dtos){
    serviceService.updateDetail(serviceId, mapper.dtoDetailToEntities(dtos));
    return ResponseEntity.ok().build();
  }
}
