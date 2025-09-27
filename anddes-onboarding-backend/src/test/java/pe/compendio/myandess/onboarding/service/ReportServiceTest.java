package pe.compendio.myandess.onboarding.service;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mapstruct.factory.Mappers;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import pe.compendio.myandess.onboarding.controller.dto.ReportActivityDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportGeneralRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportMatrixRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportPagedDTO;
import pe.compendio.myandess.onboarding.entity.Activity;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.entity.ProcessActivity;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContent;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContentCard;
import pe.compendio.myandess.onboarding.entity.User;
import pe.compendio.myandess.onboarding.repository.ProcessActivityContentCardRepository;
import pe.compendio.myandess.onboarding.repository.ProcessActivityContentRepository;
import pe.compendio.myandess.onboarding.repository.ProcessActivityRepository;
import pe.compendio.myandess.onboarding.repository.ProcessRepository;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ReportServiceTest {

  @Mock
  private ProcessRepository processRepository;
  @Mock
  private ProcessActivityRepository processActivityRepository;
  @Mock
  private ProcessActivityContentRepository processActivityContentRepository;
  @Mock
  private ProcessActivityContentCardRepository processActivityContentCardRepository;

  private ReportService reportService;

  private Process process;
  private ProcessActivity elearningActivity;
  private ProcessActivity generalActivityCompleted;
  private ProcessActivity generalActivityPending;
  private ProcessActivityContent contentWithResult;
  private ProcessActivityContent contentPending;

  @BeforeEach
  void setUp() {
    Mapper mapper = Mappers.getMapper(Mapper.class);
    reportService = new ReportService(processRepository, processActivityRepository, processActivityContentRepository,
      processActivityContentCardRepository, mapper);

    User user = new User();
    user.setId(1L);
    user.setFullname("Ana Diaz");
    user.setDni("12345678");

    process = new Process();
    process.setId(1L);
    process.setUser(user);
    process.setStartDate(LocalDate.of(2024, 1, 10));
    process.setFinished(false);

    Activity generalActivity = new Activity();
    generalActivity.setId(10L);
    generalActivity.setName("Inducción");
    generalActivity.setCode("GENERAL");

    generalActivityCompleted = new ProcessActivity();
    generalActivityCompleted.setId(100L);
    generalActivityCompleted.setActivity(generalActivity);
    generalActivityCompleted.setProcess(process);
    generalActivityCompleted.setCompleted(true);
    generalActivityCompleted.setCompletionDate(LocalDateTime.of(2024, 1, 12, 9, 0));

    generalActivityPending = new ProcessActivity();
    generalActivityPending.setId(101L);
    generalActivityPending.setActivity(generalActivity);
    generalActivityPending.setProcess(process);
    generalActivityPending.setCompleted(false);

    Activity elearning = new Activity();
    elearning.setId(11L);
    elearning.setName("E-Learning");
    elearning.setCode(Constants.ACTIVITY_INDUCTION_ELEARNING);

    elearningActivity = new ProcessActivity();
    elearningActivity.setId(200L);
    elearningActivity.setActivity(elearning);
    elearningActivity.setProcess(process);
    elearningActivity.setCompleted(false);
    elearningActivity.setCompletionDate(LocalDateTime.of(2024, 1, 15, 18, 0));

    contentWithResult = new ProcessActivityContent();
    contentWithResult.setId(1000L);
    contentWithResult.setProcessActivity(elearningActivity);
    contentWithResult.setResult(60);
    contentWithResult.setMinimumScore(80);
    contentWithResult.setAttempts(2);
    contentWithResult.setProgress(100);

    contentPending = new ProcessActivityContent();
    contentPending.setId(1001L);
    contentPending.setProcessActivity(elearningActivity);
    contentPending.setProgress(null);
    contentPending.setMinimumScore(70);
    contentPending.setAttempts(0);

    ProcessActivityContentCard card = new ProcessActivityContentCard();
    card.setId(500L);
    card.setProcessActivityContent(contentWithResult);
    card.setReadDateServer(LocalDateTime.now());

    when(processRepository.findAllByStartDateBetweenAndUser_FullnameContainingIgnoreCase(any(), any(), any(), any()))
      .thenAnswer(invocation -> new PageImpl<>(List.of(process), invocation.getArgument(3), 1));
    when(processRepository.findAllByStartDateBetweenAndFinishedIsTrueAndUser_FullnameContainingIgnoreCase(any(), any(), any(), any()))
      .thenAnswer(invocation -> new PageImpl<>(List.of(process), invocation.getArgument(3), 1));
    when(processRepository.findAllByStartDateBetweenAndFinishedIsFalseAndUser_FullnameContainingIgnoreCase(any(), any(), any(), any()))
      .thenAnswer(invocation -> new PageImpl<>(List.of(process), invocation.getArgument(3), 1));
    when(processRepository.findAllByStartDateBetweenAndDelayedIsTrueAndUser_FullnameContainingIgnoreCase(any(), any(), any(), any()))
      .thenAnswer(invocation -> new PageImpl<>(List.of(process), invocation.getArgument(3), 1));

    when(processActivityRepository.findByProcess_IdIn(any()))
      .thenReturn(List.of(generalActivityCompleted, generalActivityPending, elearningActivity));
    when(processActivityRepository.findByProcess_Id(process.getId()))
      .thenReturn(List.of(generalActivityCompleted, generalActivityPending, elearningActivity));
    when(processActivityRepository.findFirstByProcess_IdAndActivity_Code(process.getId(), Constants.ACTIVITY_INDUCTION_ELEARNING))
      .thenReturn(Optional.of(elearningActivity));

    when(processActivityContentRepository.findByProcessActivity_Process_IdIn(any()))
      .thenReturn(List.of(contentWithResult, contentPending));
    when(processActivityContentRepository.findByProcessActivity_Process_Id(process.getId()))
      .thenReturn(List.of(contentWithResult, contentPending));

    when(processActivityContentCardRepository.findByProcessActivityContent_ProcessActivity_Process_IdIn(any()))
      .thenReturn(List.of(card));
  }

  @Test
  void shouldBuildGeneralReport() {
    ReportPagedDTO<ReportGeneralRowDTO> report = reportService.getGeneralReport(LocalDate.of(2024, 1, 1),
      LocalDate.of(2024, 12, 31), "", "", 0, 20, "user.fullname", "asc");

    assertThat(report.getTotal()).isEqualTo(1);
    ReportGeneralRowDTO row = report.getData().get(0);
    assertThat(row.getCompletedActivities()).isEqualTo(1);
    assertThat(row.getTotalActivities()).isEqualTo(3);
    assertThat(row.getState()).isEqualTo("Pendiente");
  }

  @Test
  void shouldTranslateCollaboratorSortKey() {
    reportService.getGeneralReport(LocalDate.of(2024, 1, 1),
      LocalDate.of(2024, 12, 31), "", "", 0, 20, "fullName", "asc");

    ArgumentCaptor<PageRequest> pageRequestCaptor = ArgumentCaptor.forClass(PageRequest.class);
    verify(processRepository).findAllByStartDateBetweenAndUser_FullnameContainingIgnoreCase(any(), any(), any(),
      pageRequestCaptor.capture());

    PageRequest captured = pageRequestCaptor.getValue();
    Sort.Order order = captured.getSort().getOrderFor("user.fullname");
    assertThat(order).isNotNull();
    assertThat(order.getDirection()).isEqualTo(Sort.Direction.ASC);
  }

  @Test
  void shouldBuildElearningReport() {
    ReportPagedDTO<ReportElearningRowDTO> report = reportService.getElearningReport(LocalDate.of(2024, 1, 1),
      LocalDate.of(2024, 12, 31), "", "", 0, 20, "user.fullname", "asc");

    assertThat(report.getTotal()).isEqualTo(1);
    ReportElearningRowDTO row = report.getData().get(0);
    assertThat(row.getDni()).isEqualTo("12345678");
    assertThat(row.getFullName()).isEqualTo("Ana Diaz");
    assertThat(row.getStartDate()).isEqualTo(LocalDate.of(2024, 1, 10));
    assertThat(row.getFinishDate()).isEqualTo(LocalDateTime.of(2024, 1, 15, 18, 0));
    assertThat(row.getProgress()).isEqualTo(50.0);
    assertThat(row.getState()).isEqualTo("Pendiente");
  }

  @Test
  void shouldMarkElearningAsCompletedWhenAllContentsFinished() {
    contentPending.setProgress(100);

    ReportPagedDTO<ReportElearningRowDTO> report = reportService.getElearningReport(LocalDate.of(2024, 1, 1),
      LocalDate.of(2024, 12, 31), "", "", 0, 20, "user.fullname", "asc");

    ReportElearningRowDTO row = report.getData().get(0);
    assertThat(row.getProgress()).isEqualTo(100.0);
    assertThat(row.getState()).isEqualTo("Completado");
  }

  @Test
  void shouldBuildMatrixReport() {
    ReportPagedDTO<ReportMatrixRowDTO> report = reportService.getMatrixReport(LocalDate.of(2024, 1, 1),
      LocalDate.of(2024, 12, 31), "", "", 0, 20, "user.fullname", "asc");

    assertThat(report.getTotal()).isEqualTo(1);
    ReportMatrixRowDTO row = report.getData().get(0);
    assertThat(row.getGeneralState()).isEqualTo("Pendiente");
    assertThat(row.getElearningState()).isEqualTo("Pendiente");
  }

  @Test
  void shouldReturnGeneralDetailsWithCalculatedStates() {
    List<ReportActivityDetailDTO> details = reportService.getGeneralDetails(process.getId(),
      null, null, "activityName", "asc");

    assertThat(details).hasSize(3);
    assertThat(details).extracting(ReportActivityDetailDTO::getState)
      .containsExactlyInAnyOrder("Completado", "Pendiente", "Pendiente");
  }

  @Test
  void shouldReturnElearningDetails() {
    List<ReportElearningDetailDTO> details = reportService.getElearningDetails(process.getId());

    assertThat(details).hasSize(2);
    assertThat(details)
      .extracting(ReportElearningDetailDTO::getState)
      .containsExactlyInAnyOrder("Desaprobado", "Pendiente");
  }

  @Test
  void shouldGenerateGeneralWorkbookWithHeaders() throws Exception {
    try (Workbook workbook = reportService.buildWorkbook("general",
      LocalDate.of(2024, 1, 1), LocalDate.of(2024, 12, 31), "", "", "user.fullname", "asc")) {
      Sheet sheet = workbook.getSheetAt(0);
      Row header = sheet.getRow(0);

      assertThat(header.getCell(0).getStringCellValue()).isEqualTo("ID Proceso");
      assertThat(header.getCell(1).getStringCellValue()).isEqualTo("DNI");
      assertThat(header.getCell(2).getStringCellValue()).isEqualTo("Colaborador");
      assertThat(header.getCell(3).getStringCellValue()).isEqualTo("Retrasado");
      assertThat(header.getCell(4).getStringCellValue()).isEqualTo("Fecha Inicio");
      assertThat(header.getCell(5).getStringCellValue()).isEqualTo("Fecha Fin");
      assertThat(header.getCell(6).getStringCellValue()).isEqualTo("Total Actividades");
      assertThat(header.getCell(7).getStringCellValue()).isEqualTo("Actividades Completadas");
      assertThat(header.getCell(8).getStringCellValue()).isEqualTo("Avance (%)");
      assertThat(header.getCell(9).getStringCellValue()).isEqualTo("Estado");
    }
  }

  @Test
  void shouldGenerateElearningWorkbookWithHeaders() throws Exception {
    try (Workbook workbook = reportService.buildWorkbook("elearning",
      LocalDate.of(2024, 1, 1), LocalDate.of(2024, 12, 31), "", "", "user.fullname", "asc")) {
      Sheet sheet = workbook.getSheetAt(0);
      Row header = sheet.getRow(0);

      assertThat(header.getCell(0).getStringCellValue()).isEqualTo("ID Proceso");
      assertThat(header.getCell(1).getStringCellValue()).isEqualTo("DNI");
      assertThat(header.getCell(2).getStringCellValue()).isEqualTo("Colaborador");
      assertThat(header.getCell(3).getStringCellValue()).isEqualTo("Fecha Inicio");
      assertThat(header.getCell(4).getStringCellValue()).isEqualTo("Fecha Fin");
      assertThat(header.getCell(5).getStringCellValue()).isEqualTo("Avance (%)");
      assertThat(header.getCell(6).getStringCellValue()).isEqualTo("Estado");
    }
  }
}
