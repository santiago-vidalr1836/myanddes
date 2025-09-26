package pe.compendio.myandess.onboarding.util;

import io.micrometer.common.util.StringUtils;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import pe.compendio.myandess.onboarding.controller.dto.*;
import pe.compendio.myandess.onboarding.entity.*;
import pe.compendio.myandess.onboarding.entity.Process;

import java.util.List;
import java.util.Objects;

@org.mapstruct.Mapper(componentModel = "spring")
public abstract class Mapper {

  public User dtoToEntity(UserEditDTO userEditDTO) {
    User user = new User();
    user.setId(userEditDTO.getId());
    user.setFullname(userEditDTO.getFullname());
    user.setJob(userEditDTO.getJob());
    user.setImage(userEditDTO.getImage());
    user.setEmail(userEditDTO.getEmail());
    user.setRoles(userEditDTO.getRoles());
    if (Objects.nonNull(userEditDTO.getBossId())) {
      User boss = new User();
      boss.setId(userEditDTO.getBossId());
      user.setBoss(boss);
    }
    return user;
  }

  public User loadDtoToUserEntity(UserLoadDTO dto) {
    User user = new User();
    user.setDni(dto.getDni());
    user.setJob(dto.getJob());
    user.setFullname(dto.getFullname());
    user.setEmail(dto.getEmail());
    if (StringUtils.isNotEmpty(dto.getBossFullname())) {
      var boss = new User();
      boss.setFullname(dto.getBossFullname());
      user.setBoss(boss);
    }
    return user;
  }

  public Process processAddDTOToEntity(ProcessAddDTO dto){
    Process process= new Process();
    var user = new User();
    user.setId(dto.getUserId());
    process.setUser(user);
    process.setStartDate(dto.getStartDate());
    process.setHourOnsite(dto.getHourOnsite());
    process.setPlaceOnsite(dto.getPlaceOnsite());
    process.setHourRemote(dto.getHourRemote());
    process.setLinkRemote(dto.getLinkRemote());
    return process;
  }

  public abstract List<User> loadDtosToUserEntities(List<UserLoadDTO> dto);

  public abstract List<UserDTO> userEntitiesToUserDTO(List<User> entities);

  @Mapping(target = "boss",qualifiedByName = "bossWithoutBoss")
  public abstract UserDTO userEntityToDTO(User entity);

  @Named( "bossWithoutBoss" )
  @Mapping(target = "boss",ignore = true)
  public abstract UserDTO bossEntityToDTO(User user);

  public abstract ToolDTO entityToDto(Tool tool);

  public abstract Tool dtoToEntity(ToolDTO dto);

  public abstract List<ToolDTO> entitiesToDtos(List<Tool> tool);

  public abstract List<Tool> dtosToEntities(List<ToolDTO> dto);

  public abstract List<Service> dtoToEntities(List<ServiceDTO> dtos);

  public abstract Service dtoToEntity(ServiceDTO dto);

  public abstract List<ServiceDetail> dtoDetailToEntities(List<ServiceDetailDTO> dtos);

  public abstract ServiceDetail dtoToEntity(ServiceDetailDTO dto);

  public abstract List<ServiceDTO> entitiesToDto(List<Service> entities);

  public abstract ServiceDTO entityToDto(Service dto);

  public abstract List<ServiceDetailDTO> entityToDto(List<ServiceDetail> details);

  public abstract ServiceDetailDTO entityToDto(ServiceDetail entity);

  public abstract List<ProcessDTO> processEntityToDTO(List<Process> content);

  public abstract ProcessDTO processEntityToDTO(Process entity);
  public abstract Process processDTOToEntity(ProcessDTO dto);

  public abstract List<ActivityDTO> activityEntitiesToDTO(List<Activity> content);

  public abstract ActivityDTO activityEntitiesToDTO(Activity content);

  public abstract List<FirstDayInformationItemDTO> firstDayEntitiesToDTO(List<FirstDayInformationItem> firstDayInformationItems);

  public abstract FirstDayInformationItemDTO firstDayEntityToDTO(FirstDayInformationItem firstDayInformationItem);

  public abstract FirstDayInformationItem firstDayDTOToEntity(FirstDayInformationItemDTO dto);


  public abstract CEOPresentationDTO ceoPresentationEntityToDto(CEOPresentation entity);

  public abstract CEOPresentation ceoPresentationDTOToEntity(CEOPresentationDTO dto);

  public abstract OnSiteInductionDTO onSiteInductionEntityToDto(OnSiteInduction entity);

  public abstract OnSiteInduction onSiteInductionDTOToEntity(OnSiteInductionDTO dto);

  public abstract RemoteInductionDTO remoteInductionEntityToDto(RemoteInduction entity);

  public abstract RemoteInduction remoteInductionDTOToEntity(RemoteInductionDTO dto);

  public abstract ELearningContentDTO eLearningContentEntityToDto(ELearningContent entity);

  public abstract List<ELearningContentDTO> eLearningContentEntitiesToDtos(List<ELearningContent> entities);

  public abstract List<ELearningContentCardDTO> eLearningContentCardEntitiesToDtos(List<ELearningContentCard> entities);

  public abstract ELearningContentCardDTO eLearningContentCardEntityToDto(ELearningContentCard entity);

  public abstract List<ELearningContentCardOptionDTO> eLearningContentCardOptionEntitiesToDtos(List<ELearningContentCardOption> eLearningContent);

  public abstract ELearningContentCardOptionDTO eLearningContentCardOptionEntityToDto(ELearningContentCardOption eLearningContent);


  public abstract ELearningContent eLearningContentDTOToEntity(ELearningContentDTO dto);

  public abstract List<ELearningContentCard> eLearningContentCardDTOstoEntities(List<ELearningContentCardDTO> dtos);

  public abstract ELearningContentCard eLearningContentCardDTOToEntity(ELearningContentCardDTO eLearningContent);

  public abstract List<ELearningContentCardOption> eLearningContentCardOptionDTOsToEntities(List<ELearningContentCardOptionDTO> dtos);

  public abstract ELearningContentCardOption eLearningContentCardOptionDtoToEntity(ELearningContentCardOptionDTO dto);

  public abstract ProcessActivityDTO processActivityEntityToDTO(ProcessActivity entity);
  public abstract List<ProcessActivityDTO> processActivityEntitiesToDTOs(List<ProcessActivity> entity);

  public abstract ProcessActivity processActivityDTOToEntity(ProcessActivityDTO entity);
  public abstract List<ProcessActivity> processActivityDTOToEntities(List<ProcessActivityDTO> entity);

  public abstract ProcessActivityContentDTO processActivityContentEntityToDTO(ProcessActivityContent processActivityContent);

  @Mapping(target = "activityId", source = "id")
  @Mapping(target = "activityName", source = "activity.name")
  @Mapping(target = "state", ignore = true)
  public abstract ReportActivityDetailDTO processActivityToReportActivityDetail(ProcessActivity processActivity);

  public abstract List<ReportActivityDetailDTO> processActivitiesToReportActivityDetails(List<ProcessActivity> processActivities);

  @Mapping(target = "contentId", source = "content.id")
  @Mapping(target = "courseName", source = "content.name")
  @Mapping(target = "state", ignore = true)
  public abstract ReportElearningDetailDTO processActivityContentToReportElearningDetail(ProcessActivityContent processActivityContent);

  public abstract List<ReportElearningDetailDTO> processActivityContentsToReportElearningDetails(List<ProcessActivityContent> contents);
}
