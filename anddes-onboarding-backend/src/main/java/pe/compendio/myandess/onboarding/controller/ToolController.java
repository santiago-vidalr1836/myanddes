package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.ToolDTO;
import pe.compendio.myandess.onboarding.service.ToolService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/tools")
public class ToolController {
  @Autowired
  ToolService toolService;
  @Autowired
  Mapper mapper;

  @Operation(summary = "Listar las herramientas")
  @GetMapping
  public List<ToolDTO> list(){
    return mapper.entitiesToDtos(toolService.list());
  }

  @Operation(summary = "Agregar una herramienta")
  @PostMapping
  public ResponseEntity<?> add(@RequestBody ToolDTO dto){
    toolService.add(mapper.dtoToEntity(dto));
    return ResponseEntity.ok().build();
  }

  @Operation(summary = "Actualizar una herramienta")
  @PutMapping("/{toolId}")
  public ResponseEntity<?> update(@PathVariable Long toolId, @RequestBody ToolDTO dto){
    dto.setId(toolId);
    toolService.update(mapper.dtoToEntity(dto));
    return ResponseEntity.ok().build();
  }
}
