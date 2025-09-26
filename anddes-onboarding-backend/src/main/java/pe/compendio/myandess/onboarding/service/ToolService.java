package pe.compendio.myandess.onboarding.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pe.compendio.myandess.onboarding.entity.Tool;
import pe.compendio.myandess.onboarding.repository.ToolRepository;

import java.util.List;

@Service
public class ToolService {
  @Autowired
  ToolRepository toolRepository;

  public List<Tool> list(){
    return (List<Tool>) toolRepository.findAll();
  }
  public Tool add(Tool tool){
    return toolRepository.save(tool);
  }
  public Tool update(Tool tool){
    var optional = toolRepository.findById(tool.getId());
    if (optional.isPresent()){
      var toolToUpdate = optional.get();
      toolToUpdate.setName(tool.getName());
      toolToUpdate.setDescription(tool.getDescription());
      toolToUpdate.setLink(tool.getLink());
      toolToUpdate.setCover(tool.getCover());
      return toolRepository.save(toolToUpdate);
    }else return null;
  }
}
