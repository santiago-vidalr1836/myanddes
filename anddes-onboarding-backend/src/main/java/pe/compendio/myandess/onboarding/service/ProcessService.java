package pe.compendio.myandess.onboarding.service;

import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import pe.compendio.myandess.onboarding.controller.dto.ProcessActivityContentCardAnswerDTO;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.entity.*;
import pe.compendio.myandess.onboarding.repository.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@Slf4j
public class ProcessService {

  @Autowired
  UserRepository userRepository;
  @Autowired
  ActivityRepository activityRepository;
  @Autowired
  ELearningContentRepository eLearningContentRepository;
  @Autowired
  ELearningContentCardRepository eLearningContentCardRepository;
  @Autowired
  ELearningContentCardOptionRepository eLearningContentCardOptionRepository;

  @Autowired
  ProcessRepository processRepository;
  @Autowired
  ProcessActivityRepository processActivityRepository;
  @Autowired
  ProcessActivityContentRepository processActivityContentRepository;
  @Autowired
  ProcessActivityContentCardRepository processActivityContentCardRepository;

  @Autowired
  DateTimeFormatter dateTimeFormatter;

  public Page<Process> list(Integer page, Integer pageSize, String orderBy, String direction) {
    PageRequest pageRequest = PageRequest.of(page, pageSize, Sort.Direction.fromString(direction), orderBy);
    return processRepository.findAll(pageRequest);
  }


  public void add(Process process) {
    var optional = userRepository.findById(process.getUser().getId());
    if (optional.isPresent()) {
      var user = optional.get();
      user.setOnItinerary(true);
      user.setFinishedItinerary(false);
      userRepository.save(user);

      process.setUser(user);
      process.setStartDate(process.getStartDate());
      process.setStatus(0);
      process.setResults(Arrays.asList("-", "-", "-", "-"));
      process.setDelayed(false);
      process.setFinished(false);
      process.setWelcomed(false);
      process = processRepository.save(process);

      List<Activity> activities = (List<Activity>) activityRepository.findAll();
      ProcessActivity processActivity;
      for (Activity activity : activities) {
        processActivity = new ProcessActivity();
        processActivity.setActivity(activity);
        processActivity.setProcess(process);
        processActivity.setCompleted(false);
        processActivity.setCompletionDate(null);

        processActivityRepository.save(processActivity);
      }
    }
  }

  public List<ProcessActivity> listActivities(Long processId) {
    return processActivityRepository.findByProcess_Id(processId);
  }

  public void changeCompleteActivity(Long activityId, boolean completed) {
    var optional = processActivityRepository.findById(activityId);
    if (optional.isPresent()) {
      var processActivityToUpdate = optional.get();
      processActivityToUpdate.setCompleted(completed);
      processActivityRepository.save(processActivityToUpdate);
      reviewProcess(processActivityToUpdate.getProcess());
    }
  }

  public Integer countProcessComplete(LocalDate startDate, LocalDate endDate) {
    return processRepository.countByStartDateBetweenAndFinishedIsTrue(startDate, endDate);
  }

  public Integer countProcessTotal(LocalDate startDate, LocalDate endDate) {
    return processRepository.countByStartDateBetween(startDate, endDate);
  }

  public Integer countProcessDelayedAndNotFinished(LocalDate startDate, LocalDate endDate) {
    return processRepository.countByStartDateBetweenAndFinishedIsFalseAndDelayedIsTrue(startDate, endDate);
  }

  public List<Integer> findIndicatorProcessInductionELearningFinished(LocalDate startDate, LocalDate endDate) {
    List<ProcessActivityContent> contents = processActivityContentRepository.findByResultIsNotNullAndProcessActivity_Process_StartDateBetween( startDate, endDate);
    List<Integer> results = new ArrayList<>();
    results.add(contents.size());
    var optionalDouble = contents.stream().mapToDouble(ProcessActivityContent::getResult).average();
    Double average = 0.0;
    if (optionalDouble.isPresent()) {
      average = optionalDouble.getAsDouble();
    }
    results.add(average.intValue());
    return results;
  }

  public List<Process> findByStartDateBeforeAndFinishedIsFalseAndDelayedIsFalse(LocalDate date) {
    return processRepository.findByStartDateBeforeAndFinishedIsFalseAndDelayedIsFalse(date);
  }

  public void updateProcessDelayed(Process process) {
    process.setDelayed(true);
    processRepository.save(process);
  }

  public ByteArrayOutputStream downloadProcessFinished() throws IOException {
    Workbook workbook = new XSSFWorkbook();
    Sheet sheet = workbook.createSheet("ProcesosFinalizados");

    List<Process> processes = processRepository.findByOrderByIdDesc();

    Row row = sheet.createRow(0);
    row.createCell(0).setCellValue("Id");
    row.createCell(1).setCellValue("Nombre");
    row.createCell(2).setCellValue("Fecha Inicio");
    row.createCell(3).setCellValue("Status");
    row.createCell(4).setCellValue("Elearning");
    Process process;


    for (int i = 0; i < processes.size(); i++) {
      row = sheet.createRow(i + 1);

      process = processes.get(i);

      row.createCell(0).setCellValue(process.getId());
      row.createCell(1).setCellValue(process.getUser().getFullname());
      row.createCell(2).setCellValue(process.getStartDate().format(dateTimeFormatter));
      row.createCell(3).setCellValue(process.getStatus());
      row.createCell(4).setCellValue(String.join(",", process.getResults()));
    }
    // Write the workbook to a ByteArrayOutputStream
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    workbook.write(stream);

    return stream;
  }

  public ByteArrayOutputStream downloadProcessAnswers() throws IOException {
    Workbook workbook = new XSSFWorkbook();
    Sheet sheet = workbook.createSheet("ProcesosFinalizados");

    List<ProcessActivityContentCard> answers = processActivityContentCardRepository.findByCard_Type(Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION);

    Row row = sheet.createRow(0);
    row.createCell(0).setCellValue("Usuario");
    row.createCell(1).setCellValue("Curso");
    row.createCell(2).setCellValue("Pregunta");
    row.createCell(3).setCellValue("Opción Marcada");
    row.createCell(4).setCellValue("Status");

    int i = 1;
    for (ProcessActivityContentCard contentCard:answers) {
      row = sheet.createRow(i++);

      row.createCell(0).setCellValue(contentCard.getProcessActivityContent().getProcessActivity().getProcess().getUser().getEmail());
      row.createCell(1).setCellValue(contentCard.getProcessActivityContent().getProcessActivity().getActivity().getName());
      row.createCell(2).setCellValue(contentCard.getCard().getContent());
      row.createCell(3).setCellValue(contentCard.getAnswer()!=null?contentCard.getAnswer().getDescription():"-");
      row.createCell(4).setCellValue(contentCard.getAnswer()!=null?contentCard.getAnswer().isCorrect()?"Correcto":"Incorrecto":"-");
    }
    // Write the workbook to a ByteArrayOutputStream
    ByteArrayOutputStream stream = new ByteArrayOutputStream();
    workbook.write(stream);

    return stream;
  }

  public Process findByUserId(Long idUser) {
    return processRepository.findByUser_Id(idUser).orElse(null);
  }

  public List<ProcessActivity> findActivityByProcessId(Long processId) {
    return processActivityRepository.findByProcess_Id(processId);
  }

  public void updateCompletedActivities(List<ProcessActivity> processActivities) {
    ProcessActivity processActivityToUpdate;
    Optional<ProcessActivity> optional;
    for (ProcessActivity processActivity : processActivities) {
      optional = processActivityRepository.findById(processActivity.getId());
      if (optional.isPresent()) {
        processActivityToUpdate = optional.get();
        processActivityToUpdate.setCompleted(true);
        processActivityToUpdate.setCompletionDate(LocalDateTime.now());
        processActivityRepository.save(processActivityToUpdate);
      }
    }
  }

  public void update(Process process) {
    var optional = processRepository.findById(process.getId());
    if (optional.isPresent()) {
      var processToUpdate = optional.get();
      processToUpdate.setStartDate(process.getStartDate());
      processRepository.save(processToUpdate);
    }
  }

  public void updateWelcomed(Long processId) {
    var optional = processRepository.findById(processId);
    if (optional.isPresent()) {
      var processToUpdate = optional.get();
      processToUpdate.setWelcomed(true);
      processRepository.save(processToUpdate);
    }
  }

  public void updateCompletedActivity(Long activityId) {
    log.info("updateCompletedActivity processActivity={}",activityId);
    var optional = processActivityRepository.findById(activityId);
    if (optional.isPresent()) {
      ProcessActivity processActivityToUpdate = optional.get();
      processActivityToUpdate.setCompleted(true);
      processActivityToUpdate.setCompletionDate(LocalDateTime.now());
      processActivityRepository.save(processActivityToUpdate);

      reviewProcess(processActivityToUpdate.getProcess());
    }
  }
  private void reviewProcessActivity(Process process, ProcessActivity processActivity) {
    List<ELearningContent> contents = (List<ELearningContent>) eLearningContentRepository.findAll();
    List<String> results = new ArrayList<>();

    int countELearningsFinished = 0;
    for (ELearningContent content : contents) {
      var optional = processActivityContentRepository.findByProcessActivity_IdAndContent_Id(processActivity.getId(), content.getId());
      if (optional.isPresent() && Objects.nonNull(optional.get().getResult())) {
        results.add(optional.get().getResult().toString());
        countELearningsFinished++;
      } else {
        results.add("-");
      }
    }
    if (countELearningsFinished == contents.size()) {
      processActivity.setCompleted(true);
      processActivity.setCompletionDate(LocalDateTime.now());
      processActivityRepository.save(processActivity);
    }

    process.setResults(results);
    process = processRepository.save(process);

    reviewProcess(process);
  }

  private void reviewProcess(Process process) {
    List<ProcessActivity> processActivities = processActivityRepository.findByProcess_Id(process.getId());
    int completedProcess= Math.toIntExact(processActivities.stream().filter(ProcessActivity::isCompleted).count());
    int totalProcess=processActivities.size();
    process.setStatus(completedProcess*100/totalProcess);
    if (processActivities.stream().allMatch(ProcessActivity::isCompleted)) {
      process.setFinished(true);
      process.setStatus(100);
    }
    processRepository.save(process);
  }

  public ProcessActivity findActivityById(Long activityId) {
    return processActivityRepository.findById(activityId).orElse(null);
  }

  public ProcessActivityContent findProcessActivityContentByElearningId(Long processActivityId,Long eLearningContentId) {
    return processActivityContentRepository.findByProcessActivity_IdAndContent_Id(processActivityId,eLearningContentId).orElse(null);
  }
  public void createNewProcessActivityContent(Long processActivityId,Long eLearningContentId){
    var optionalProcessActivityContent = processActivityContentRepository.findByProcessActivity_IdAndContent_Id(processActivityId,eLearningContentId);
    if(optionalProcessActivityContent.isPresent()) return;

    var optionalELearningContent = eLearningContentRepository.findById(eLearningContentId);
    var optionalProcessActivityId = processActivityRepository.findById(processActivityId);

    ProcessActivityContent processActivityContent=null;
    if(optionalProcessActivityId.isPresent()
      && optionalELearningContent.isPresent()){
      processActivityContent= new ProcessActivityContent();
      processActivityContent.setProcessActivity(optionalProcessActivityId.get());
      processActivityContent.setContent(optionalELearningContent.get());

      processActivityContent = processActivityContentRepository.save(processActivityContent);

      ProcessActivityContentCard processActivityContentCard;
      log.info("optionalELearningContent.get().getCards().size()="+optionalELearningContent.get().getCards().size());
      for(ELearningContentCard card : optionalELearningContent.get().getCards()){
        processActivityContentCard=new ProcessActivityContentCard();
        processActivityContentCard.setProcessActivityContent(processActivityContent);
        processActivityContentCard.setCard(card);
        processActivityContentCardRepository.save(processActivityContentCard);
      }
    }
  }
  public void updateReadAndAnswer(Long processActivityContentCardId, ProcessActivityContentCardAnswerDTO answer) {
    log.info("updateReadAndAnswer processActivityContentCardId={} ProcessActivityContentCardAnswerDTO={}" ,processActivityContentCardId,answer);
    var optional = processActivityContentCardRepository.findById(processActivityContentCardId);
    if(optional.isPresent()){
      ProcessActivityContentCard processActivityContentCard = optional.get();
      processActivityContentCard.setReadDateMobile(answer.getReadDateMobile());
      processActivityContentCard.setReadDateServer(LocalDateTime.now());
      if(Objects.nonNull(answer.getAnswer()) &&
        processActivityContentCard.getCard().getType().equals(Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)){
        var optionalELearningContentCardOption = eLearningContentCardOptionRepository.findById(answer.getAnswer().getId());
        optionalELearningContentCardOption.ifPresent(option->{
          processActivityContentCard.setAnswer(option);
          processActivityContentCard.setPoints(option.isCorrect()?Constants.CORRECT:null);
        });
      }
      processActivityContentCardRepository.save(processActivityContentCard);
      calculateProgress(processActivityContentCard.getProcessActivityContent().getId());
    }
  }
  public Integer calculateResult(Long processActivityContentId){
    var optional= processActivityContentRepository.findById(processActivityContentId);
    if(optional.isPresent()){
      var processActivityContent = optional.get();
      int totalQuestions=0;
      int totalCorrect = 0;
      for (ProcessActivityContentCard processActivityContentCard : optional.get().getCards()) {
        if(processActivityContentCard.getCard().getType().equals(Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION)) {
          totalQuestions++;
          if(Objects.equals(processActivityContentCard.getPoints(), Constants.CORRECT)) {
            totalCorrect++;
          }
        }
      }
      int result = (totalQuestions > 0) ? totalCorrect * 100/ totalQuestions  : 0;
      processActivityContent.setResult(result);
      processActivityContent.setProgress(100);
      processActivityContentRepository.save(processActivityContent);
      reviewProcessActivity(optional.get().getProcessActivity().getProcess(), optional.get().getProcessActivity());
      return result;
    }
    return null;
  }
  public void calculateProgress(Long processActivityContentId){
    var optional= processActivityContentRepository.findById(processActivityContentId);
    if(optional.isPresent()){
      var processActivityContent = optional.get();
      int totalQuestions = optional.get().getCards().size();
      int totalFinished = 0;
      for (ProcessActivityContentCard processActivityContentCard : optional.get().getCards()) {
        if(Objects.nonNull(processActivityContentCard.getReadDateMobile())) {
          totalFinished++;
        }
      }
      int progress = (totalQuestions > 0) ? totalFinished * 100/ totalQuestions  : 0;
      processActivityContent.setProgress(progress);
      processActivityContentRepository.save(processActivityContent);
    }
  }
}
