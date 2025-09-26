package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class OnboardingDTO {
  CEOPresentationDTO ceoPresentation;
  List<FirstDayInformationItemDTO> firstDayInformationItems;
  OnSiteInductionDTO onSiteInduction;
  RemoteInductionDTO remoteInduction;
  List<ELearningContentDTO> eLearningContents;
  List<UserDTO> team;
}
