package pe.compendio.myandess.onboarding.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;
import pe.compendio.myandess.onboarding.entity.*;
import pe.compendio.myandess.onboarding.repository.*;

import java.util.List;
import java.util.Objects;

@Component
public class ActivityService {
  @Autowired
  ActivityRepository activityRepository;

  public List<Activity> list() {
    return (List<Activity>) activityRepository.findAll();
  }

  public List<Activity> listByParentCode(String parentCode) {
    return activityRepository.findByParentCodeOrderByIdAsc(parentCode);
  }

  @Autowired
  FirstDayInformationItemRepository firstDayInformationItemRepository;

  public List<FirstDayInformationItem> listFirstDayInformationItems(){
    return firstDayInformationItemRepository.findAll(Sort.by(Sort.Direction.ASC,"id"));
  }
  public void updateFirstDayInformationItem(FirstDayInformationItem firstDayInformationItem) {
    var optional = firstDayInformationItemRepository.findById(firstDayInformationItem.getId());
    if (optional.isPresent()){
      var itemToUpdate = optional.get();
      if(itemToUpdate.getType().equals(Constants.FIRST_DAY_INFORMATION_ITEM_TYPE_DEFAULT)){
        itemToUpdate.setDescription(firstDayInformationItem.getDescription());
        itemToUpdate.setBody(firstDayInformationItem.getBody());
      }else{
        itemToUpdate.setAddFromServices(firstDayInformationItem.isAddFromServices());
      }
      firstDayInformationItemRepository.save(itemToUpdate);
    }
  }

  @Autowired
  CEOPresentationRepository ceoPresentationRepository;

  public CEOPresentation listCEOPresentation() {
    var list = ceoPresentationRepository.findAll();
    if(list.iterator().hasNext())
      return list.iterator().next();
    else return null;
  }
  public void updateCEOPresentation(CEOPresentation ceoPresentation) {
    var optional = ceoPresentationRepository.findById(ceoPresentation.getId());
    if(optional.isPresent()){
      var ceoPresentationToUpdate=optional.get();
      ceoPresentationToUpdate.setUrlVideo(ceoPresentation.getUrlVideo());
      ceoPresentationToUpdate.setUrlPoster(ceoPresentation.getUrlPoster());
      ceoPresentationRepository.save(ceoPresentationToUpdate);
    }
  }

  @Autowired
  OnSiteInductionRepository onSiteInductionRepository;

  public OnSiteInduction findOnSiteInduction() {
    var list = onSiteInductionRepository.findAll();
    if(list.iterator().hasNext())
      return list.iterator().next();
    else return null;
  }
  public void updateOnSiteInduction(OnSiteInduction onSiteInduction) {
    var optional = onSiteInductionRepository.findById(onSiteInduction.getId());
    if(optional.isPresent()){
      var onSiteInductionToUpdate=optional.get();
      onSiteInductionToUpdate.setDescription(onSiteInduction.getDescription());
      onSiteInductionRepository.save(onSiteInductionToUpdate);
    }
  }

  @Autowired
  RemoteInductionRepository remoteInductionRepository;

  public RemoteInduction findRemoteInduction() {
    var list = remoteInductionRepository.findAll();
    if(list.iterator().hasNext())
      return list.iterator().next();
    else return null;
  }
  public void updateRemoteInduction(RemoteInduction remoteInduction) {
    var optional = remoteInductionRepository.findById(remoteInduction.getId());
    if(optional.isPresent()){
      var remoteInductionToUpdate=optional.get();
      remoteInductionToUpdate.setDescription(remoteInduction.getDescription());
      remoteInductionRepository.save(remoteInductionToUpdate);
    }
  }
  @Autowired
  ELearningContentRepository eLearningContentRepository;

  public List<ELearningContent> listELearningContent() {
    return eLearningContentRepository.findAllByOrderByPositionAsc();
  }

  public void updateELearningContent(ELearningContent eLearningContent) {
    var optional = eLearningContentRepository.findById(eLearningContent.getId());
    if(optional.isPresent()){
      var content=optional.get();
      for(ELearningContentCard card : eLearningContent.getCards()){
        if(Objects.isNull(card.getId())) {
          createELearningContentCard(content, card);
        }else{
          updateELearningContentCard(card);
        }
      }
    }
  }

  @Autowired
  ELearningContentCardRepository eLearningContentCardRepository;
  private void createELearningContentCard(ELearningContent content, ELearningContentCard card) {
    ELearningContentCard cardToCreate= new ELearningContentCard();
    cardToCreate.setTitle(card.getTitle());
    cardToCreate.setContent(card.getContent());
    cardToCreate.setDraft(card.isDraft());
    cardToCreate.setType(card.getType());
    cardToCreate.setELearningContent(content);
    cardToCreate.setDeleted(false);
    cardToCreate.setPosition(card.getPosition());
    cardToCreate.setUrlVideo(card.getUrlVideo());
    cardToCreate.setUrlPoster(card.getUrlPoster());
    cardToCreate = eLearningContentCardRepository.save(cardToCreate);
    if(card.getType().equals(Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)){
      for(ELearningContentCardOption option:card.getOptions()){
        createELearningContentCardOption(cardToCreate,option);
      }
    }
  }
  private void updateELearningContentCard(ELearningContentCard card) {
    var optional= eLearningContentCardRepository.findById(card.getId());
    if(optional.isPresent()){
      var cardToUpdate = optional.get();
      cardToUpdate.setTitle(card.getTitle());
      cardToUpdate.setContent(card.getContent());
      cardToUpdate.setDraft(card.isDraft());
      cardToUpdate.setDeleted(card.isDeleted());
      cardToUpdate.setPosition(card.getPosition());
      cardToUpdate.setUrlVideo(card.getUrlVideo());
      cardToUpdate.setUrlPoster(card.getUrlPoster());
      cardToUpdate = eLearningContentCardRepository.save(cardToUpdate);

      if(card.getType().equals(Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)){
        for(ELearningContentCardOption option:card.getOptions()){
          if(Objects.isNull(option.getId())){
            createELearningContentCardOption(cardToUpdate,option);
          }else{
            updateELearningContentCardOption(option);
          }
        }
      }
    }
  }

  @Autowired
  ELearningContentCardOptionRepository eLearningContentCardOptionRepository;
  private void createELearningContentCardOption(ELearningContentCard card, ELearningContentCardOption option) {
    var optionToCreate = new ELearningContentCardOption();
    optionToCreate.setELearningContentCard(card);
    optionToCreate.setDescription(option.getDescription());
    optionToCreate.setCorrect(option.isCorrect());
    optionToCreate.setDeleted(false);
    eLearningContentCardOptionRepository.save(optionToCreate);
  }
  private void updateELearningContentCardOption(ELearningContentCardOption option) {
    var optional = eLearningContentCardOptionRepository.findById(option.getId());
    if(optional.isPresent()){
      var optionToUpdate = optional.get();
      optionToUpdate.setDescription(option.getDescription());
      optionToUpdate.setCorrect(option.isCorrect());
      optionToUpdate.setDeleted(option.isDeleted());
      eLearningContentCardOptionRepository.save(optionToUpdate);
    }
  }
}
