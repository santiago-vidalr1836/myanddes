package pe.compendio.myandess.onboarding.service;

import org.springframework.beans.factory.annotation.Autowired;
import pe.compendio.myandess.onboarding.entity.Service;
import pe.compendio.myandess.onboarding.entity.ServiceDetail;
import pe.compendio.myandess.onboarding.repository.ServiceDetailRepository;
import pe.compendio.myandess.onboarding.repository.ServiceRepository;

import java.util.List;

@org.springframework.stereotype.Service
public class ServiceService {
  @Autowired
  ServiceRepository serviceRepository;
  @Autowired
  ServiceDetailRepository serviceDetailRepository;

  public List<Service> list() {
    return (List<Service>) serviceRepository.findAll();
  }
  public void update(Service service) {
    var optional = serviceRepository.findById(service.getId());
    if (optional.isPresent()){
      var serviceToUpdate = optional.get();
      serviceToUpdate.setName(service.getName());
      serviceToUpdate.setDescription(service.getDescription());
      serviceRepository.save(serviceToUpdate);
    }
  }
  public void updateDetail(Long serviceId, List<ServiceDetail> serviceDetails) {
      serviceDetails.forEach(serviceDetail -> {
        var optional=serviceDetailRepository.findById(serviceDetail.getId());
        if(optional.isPresent()) {
          var detailToUpdate=optional.get();
          detailToUpdate.setTitle(serviceDetail.getTitle());
          detailToUpdate.setDescription(serviceDetail.getDescription());
          detailToUpdate.setHidden(serviceDetail.isHidden());
          serviceDetailRepository.save(detailToUpdate);
        }
      });
  }
}
