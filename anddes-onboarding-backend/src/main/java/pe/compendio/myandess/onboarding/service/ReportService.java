package pe.compendio.myandess.onboarding.service;

import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import pe.compendio.myandess.onboarding.controller.dto.ReportActivityDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportGeneralRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportMatrixRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportPagedDTO;
import pe.compendio.myandess.onboarding.entity.Constants;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.entity.ProcessActivity;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContent;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContentCard;
import pe.compendio.myandess.onboarding.repository.ProcessActivityContentCardRepository;
import pe.compendio.myandess.onboarding.repository.ProcessActivityContentRepository;
import pe.compendio.myandess.onboarding.repository.ProcessActivityRepository;
import pe.compendio.myandess.onboarding.repository.ProcessRepository;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.text.Collator;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.TreeSet;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private static final String STATE_COMPLETED = "Completado";
    private static final String STATE_PENDING = "Pendiente";
    private static final String STATE_SUCCESSFUL = "Aprobado";
    private static final String STATE_FAILED = "Desaprobado";
    private static final String DEFAULT_SORT_PROPERTY = "user.fullname";

    private static final Map<String, String> SORT_PROPERTY_MAPPING = Map.ofEntries(
            Map.entry("collaborator", "user.fullname"),
            Map.entry("fullname", "user.fullname"),
            Map.entry("user.fullname", "user.fullname"),
            Map.entry("position", "user.job"),
            Map.entry("user.job", "user.job"),
            Map.entry("bossname", "user.boss.fullname"),
            Map.entry("user.boss.fullname", "user.boss.fullname"),
            Map.entry("startdate", "startDate"),
            Map.entry("finishDate","finishDate")
    );

    private final ProcessRepository processRepository;
    private final ProcessActivityRepository processActivityRepository;
    private final ProcessActivityContentRepository processActivityContentRepository;
    private final ProcessActivityContentCardRepository processActivityContentCardRepository;
    private final Mapper mapper;

    public ReportPagedDTO<ReportGeneralRowDTO> getGeneralReport(LocalDate startDate,
                                                                LocalDate endDate,
                                                                String state,
                                                                String search,
                                                                Integer page,
                                                                Integer pageSize,
                                                                String orderBy,
                                                                String direction) {
        PageRequest pageRequest = createPageRequest(page, pageSize, orderBy, direction);
        Page<Process> processPage = fetchProcesses(startDate, endDate, state, search, pageRequest, true);
        Map<Long, List<ProcessActivity>> activitiesByProcess = loadActivities(processPage.getContent());

        List<ReportGeneralRowDTO> rows = processPage.getContent().stream()
                .map(process -> buildGeneralRow(process, activitiesByProcess.getOrDefault(process.getId(), Collections.emptyList())))
                .toList();

        return new ReportPagedDTO<>(processPage.getTotalElements(), rows);
    }

    public ReportPagedDTO<ReportElearningRowDTO> getElearningReport(LocalDate startDate,
                                                                    LocalDate endDate,
                                                                    String state,
                                                                    String search,
                                                                    Integer page,
                                                                    Integer pageSize,
                                                                    String orderBy,
                                                                    String direction) {
        PageRequest fullRequest = createPageRequest(0, Integer.MAX_VALUE, orderBy, direction);
        Page<Process> processPage = fetchProcesses(startDate, endDate, null, search, fullRequest, false);

        Map<Long, List<ProcessActivity>> activitiesByProcess = loadActivities(processPage.getContent());
        Map<Long, ProcessActivity> elearningActivityByProcess = extractElearningActivities(activitiesByProcess);
        Map<Long, List<ProcessActivityContent>> contentsByProcess = loadElearningContents(processPage.getContent());

        List<ReportElearningRowDTO> allRows = processPage.getContent().stream()
                .map(process -> buildElearningRow(process,
                        elearningActivityByProcess.get(process.getId()),
                        contentsByProcess.getOrDefault(process.getId(), Collections.emptyList())))
                .toList();

        String normalizedState = normalizeState(state);
        List<ReportElearningRowDTO> filteredRows = allRows.stream()
                .filter(row -> filterElearningRow(row, normalizedState))
                .collect(Collectors.toList());

        Comparator<ReportElearningRowDTO> comparator = buildElearningComparator(orderBy, direction);
        filteredRows.sort(comparator);

        List<ReportElearningRowDTO> paged = applyPagination(filteredRows, page, pageSize);
        return new ReportPagedDTO<>(filteredRows.size(), paged);
    }

    public ReportPagedDTO<ReportMatrixRowDTO> getMatrixReport(LocalDate startDate,
                                                              LocalDate endDate,
                                                              String state,
                                                              String search,
                                                              Integer page,
                                                              Integer pageSize,
                                                              String orderBy,
                                                              String direction) {
        PageRequest pageRequest = createPageRequest(page, pageSize, orderBy, direction);
        Page<Process> processPage = fetchProcesses(startDate, endDate, state, search, pageRequest, true);

        Map<Long, List<ProcessActivity>> activitiesByProcess = loadActivities(processPage.getContent());
        Map<Long, ProcessActivity> elearningActivityByProcess = extractElearningActivities(activitiesByProcess);
        Map<Long, List<ProcessActivityContent>> contentsByProcess = loadElearningContents(processPage.getContent());

        Map<Long, ReportGeneralRowDTO> generalRows = processPage.getContent().stream()
                .collect(Collectors.toMap(Process::getId,
                        process -> buildGeneralRow(process, activitiesByProcess.getOrDefault(process.getId(), Collections.emptyList()))));

        Map<Long, ReportElearningRowDTO> elearningRows = processPage.getContent().stream()
                .collect(Collectors.toMap(Process::getId,
                        process -> buildElearningRow(process,
                                elearningActivityByProcess.get(process.getId()),
                                contentsByProcess.getOrDefault(process.getId(), Collections.emptyList()))));

        List<ReportMatrixRowDTO> matrixRows = processPage.getContent().stream()
                .map(process -> buildMatrixRow(
                        generalRows.get(process.getId()),
                        elearningRows.get(process.getId()),
                        contentsByProcess.getOrDefault(process.getId(), Collections.emptyList())))
                .toList();

        return new ReportPagedDTO<>(processPage.getTotalElements(), matrixRows);
    }

    public List<ReportActivityDetailDTO> getGeneralDetails(Long processId,
                                                           String state,
                                                           String search,
                                                           String orderBy,
                                                           String direction) {
        List<ProcessActivity> activities = processActivityRepository.findByProcess_Id(processId);
        List<ReportActivityDetailDTO> details = mapper.processActivitiesToReportActivityDetails(activities);
        details.forEach(detail -> detail.setState(detail.isCompleted() ? STATE_COMPLETED : STATE_PENDING));
        return details;
    }

    public List<ReportElearningDetailDTO> getElearningDetails(Long processId) {
        Optional<ProcessActivity> elearningActivityOptional =
                processActivityRepository.findFirstByProcess_IdAndActivity_Code(processId, Constants.ACTIVITY_INDUCTION_ELEARNING);

        if (elearningActivityOptional.isEmpty()) {
            return Collections.emptyList();
        }

        ProcessActivity elearningActivity = elearningActivityOptional.get();
        Process process = elearningActivity.getProcess();
        if (process == null) {
            return Collections.emptyList();
        }

        List<ProcessActivityContent> contents = processActivityContentRepository.findByProcessActivity_Process_Id(processId);
        if (contents == null || contents.isEmpty()) {
            return Collections.emptyList();
        }

        CardAggregation cardAggregation = loadCardAggregation(Collections.singletonList(process));
        Map<Long, Long> readByContent = cardAggregation.getReadByContent();
        Map<Long, Long> correctByContent = cardAggregation.getCorrectByContent();

        Comparator<ProcessActivityContent> byId = Comparator.comparing(content ->
                Optional.ofNullable(content.getId()).orElse(0L));

        Map<Long, List<ProcessActivityContent>> groupedContents = contents.stream()
                .filter(Objects::nonNull)
                .collect(Collectors.groupingBy(content -> {
                    if (content.getContent() != null && content.getContent().getId() != null) {
                        return content.getContent().getId();
                    }
                    return Optional.ofNullable(content.getId()).orElse(0L);
                }, LinkedHashMap::new, Collectors.toList()));

        return groupedContents.values().stream()
                .map(group -> {
                    ProcessActivityContent latestAttempt = group.stream()
                            .filter(Objects::nonNull)
                            .max(byId)
                            .orElse(null);
                    if (latestAttempt == null) {
                        return null;
                    }
                    ReportElearningDetailDTO dto = mapper.processActivityContentToReportElearningDetail(latestAttempt);
                    dto.setMinimumScore(Optional.ofNullable(dto.getMinimumScore()).orElse(0));
                    dto.setAttempts(group.size());
                    dto.setProgress(Optional.ofNullable(dto.getProgress()).orElse(0));
                    Long latestAttemptId = latestAttempt.getId();
                    int readCards = latestAttemptId != null ? readByContent.getOrDefault(latestAttemptId, 0L).intValue() : 0;
                    int correctAnswers = latestAttemptId != null ? correctByContent.getOrDefault(latestAttemptId, 0L).intValue() : 0;
                    dto.setReadCards(readCards);
                    dto.setCorrectAnswers(correctAnswers);
                    dto.setState(translateStatus(latestAttempt.getStatus()));
                    return dto;
                })
                .filter(Objects::nonNull)
                .toList();
    }
    private String translateStatus(String status) {
        if (!StringUtils.hasText(status)) {
            return STATE_PENDING;
        }
        return switch (status.trim().toUpperCase(Locale.getDefault())) {
            case "SUCCESSFULL", "SUCCESSFUL" -> STATE_SUCCESSFUL;
            case "FAILED" -> STATE_FAILED;
            case "PENDING" -> STATE_PENDING;
            default -> STATE_PENDING;
        };
    }
    public Workbook buildWorkbook(String type,
                                  LocalDate startDate,
                                  LocalDate endDate,
                                  String state,
                                  String search,
                                  String orderBy,
                                  String direction) {
        ReportType reportType = ReportType.from(type);
        if (reportType == null) {
            throw new IllegalArgumentException("Tipo de reporte no soportado: " + type);
        }

        return switch (reportType) {
            case GENERAL -> buildGeneralWorkbook(startDate, endDate, state, search, orderBy, direction);
            case ELEARNING -> buildElearningWorkbook(startDate, endDate, state, search, orderBy, direction);
            case MATRIX -> buildMatrixWorkbook(startDate, endDate, state, search, orderBy, direction);
        };
    }

    private Workbook buildGeneralWorkbook(LocalDate startDate,
                                          LocalDate endDate,
                                          String state,
                                          String search,
                                          String orderBy,
                                          String direction) {
        ReportPagedDTO<ReportGeneralRowDTO> report = getGeneralReport(startDate, endDate, state, search,
                0, Integer.MAX_VALUE, orderBy, direction);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("General");
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID Proceso");
        header.createCell(1).setCellValue("DNI");
        header.createCell(2).setCellValue("Colaborador");
        header.createCell(3).setCellValue("Retrasado");
        header.createCell(4).setCellValue("Fecha Inicio");
        header.createCell(5).setCellValue("Fecha Fin");
        header.createCell(6).setCellValue("Total Actividades");
        header.createCell(7).setCellValue("Actividades Completadas");
        header.createCell(8).setCellValue("Avance (%)");
        header.createCell(9).setCellValue("Estado");

        int rowIndex = 1;
        for (ReportGeneralRowDTO row : report.getData()) {
            Row excelRow = sheet.createRow(rowIndex++);
            excelRow.createCell(0).setCellValue(row.getProcessId());
            excelRow.createCell(1).setCellValue(Optional.ofNullable(row.getDni()).orElse(""));
            excelRow.createCell(2).setCellValue(Optional.ofNullable(row.getFullName()).orElse(""));
            excelRow.createCell(3).setCellValue(row.isDelayed());
            excelRow.createCell(4).setCellValue(row.getStartDate() != null ? row.getStartDate().toString() : "");
            excelRow.createCell(5).setCellValue(row.getFinishDate() != null ? row.getFinishDate().toString() : "");
            excelRow.createCell(6).setCellValue(row.getTotalActivities());
            excelRow.createCell(7).setCellValue(row.getCompletedActivities());
            excelRow.createCell(8).setCellValue(row.getProgress());
            excelRow.createCell(9).setCellValue(Optional.ofNullable(row.getState()).orElse(""));
        }

        return workbook;
    }

    private Workbook buildElearningWorkbook(LocalDate startDate,
                                            LocalDate endDate,
                                            String state,
                                            String search,
                                            String orderBy,
                                            String direction) {
        ReportPagedDTO<ReportElearningRowDTO> report = getElearningReport(startDate, endDate, state, search,
                0, Integer.MAX_VALUE, orderBy, direction);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Elearning");
        Row header = sheet.createRow(0);
        header.createCell(0).setCellValue("ID Proceso");
        header.createCell(1).setCellValue("DNI");
        header.createCell(2).setCellValue("Colaborador");
        header.createCell(3).setCellValue("Fecha Inicio");
        header.createCell(4).setCellValue("Fecha Fin");
        header.createCell(5).setCellValue("Avance (%)");
        header.createCell(6).setCellValue("Estado");

        int rowIndex = 1;
        for (ReportElearningRowDTO row : report.getData()) {
            Row excelRow = sheet.createRow(rowIndex++);
            excelRow.createCell(0).setCellValue(row.getProcessId());
            excelRow.createCell(1).setCellValue(Optional.ofNullable(row.getDni()).orElse(""));
            excelRow.createCell(2).setCellValue(Optional.ofNullable(row.getFullName()).orElse(""));
            excelRow.createCell(3).setCellValue(row.getStartDate() != null ? row.getStartDate().toString() : "");
            excelRow.createCell(4).setCellValue(row.getFinishDate() != null ? row.getFinishDate().toString() : "");
            excelRow.createCell(5).setCellValue(row.getProgress());
            excelRow.createCell(6).setCellValue(Optional.ofNullable(row.getState()).orElse(""));
        }

        return workbook;
    }

    private Workbook buildMatrixWorkbook(LocalDate startDate,
                                         LocalDate endDate,
                                         String state,
                                         String search,
                                         String orderBy,
                                         String direction) {
        ReportPagedDTO<ReportMatrixRowDTO> report = getMatrixReport(startDate, endDate, state, search,
                0, Integer.MAX_VALUE, orderBy, direction);

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Matriz");

        Collator collator = Collator.getInstance(Locale.getDefault());
        Comparator<String> localeComparator = collator::compare;
        List<String> contentColumns = report.getData().stream()
                .map(ReportMatrixRowDTO::getElearningResults)
                .filter(Objects::nonNull)
                .flatMap(results -> results.keySet().stream())
                .collect(Collectors.collectingAndThen(Collectors.toCollection(() -> new TreeSet<>(localeComparator)), ArrayList::new));

        List<String> baseHeaders = List.of(
                "DNI",
                "Colaborador",
                "Fecha inicio",
                "Fecha fin e-learning",
                "Avance general (completadas/totales)",
                "Estado proceso",
                "Avance e-learning (completadas/totales)"
        );

        Row header = sheet.createRow(0);
        int columnIndex = 0;
        for (String baseHeader : baseHeaders) {
            header.createCell(columnIndex++).setCellValue(baseHeader);
        }
        for (String contentHeader : contentColumns) {
            header.createCell(columnIndex++).setCellValue(contentHeader);
        }

        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy", Locale.getDefault());
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm", Locale.getDefault());

        int rowIndex = 1;
        for (ReportMatrixRowDTO row : report.getData()) {
            Row excelRow = sheet.createRow(rowIndex++);
            int cellIndex = 0;
            excelRow.createCell(cellIndex++).setCellValue(Optional.ofNullable(row.getDni()).orElse(""));
            excelRow.createCell(cellIndex++).setCellValue(Optional.ofNullable(row.getFullName()).orElse(""));
            excelRow.createCell(cellIndex++).setCellValue(formatLocalDate(row.getStartDate(), dateFormatter));
            excelRow.createCell(cellIndex++).setCellValue(formatLocalDateTime(row.getElearningFinishDate(), dateTimeFormatter));
            excelRow.createCell(cellIndex++).setCellValue(formatFraction(row.getGeneralCompletedActivities(), row.getGeneralTotalActivities()));
            excelRow.createCell(cellIndex++).setCellValue(Optional.ofNullable(row.getProcessState()).orElse(""));
            excelRow.createCell(cellIndex++).setCellValue(formatFraction(row.getElearningCompletedContents(), row.getElearningTotalContents()));

            Map<String, String> elearningResults = Optional.ofNullable(row.getElearningResults()).orElse(Collections.emptyMap());
            for (String contentHeader : contentColumns) {
                String value = elearningResults.getOrDefault(contentHeader, "-");
                excelRow.createCell(cellIndex++).setCellValue(value);
            }
        }

        return workbook;
    }

    private String formatLocalDate(LocalDate date, DateTimeFormatter formatter) {
        return Optional.ofNullable(date)
                .map(value -> value.format(formatter))
                .orElse("");
    }

    private String formatLocalDateTime(LocalDateTime date, DateTimeFormatter formatter) {
        return Optional.ofNullable(date)
                .map(value -> value.format(formatter))
                .orElse("");
    }

    private String formatFraction(int completed, int total) {
        return String.format(Locale.getDefault(), "%d/%d", completed, total);
    }

    private PageRequest createPageRequest(Integer page, Integer pageSize, String orderBy, String direction) {
        int pageNumber = page != null && page >= 0 ? page : 0;
        int size = pageSize != null && pageSize > 0 ? pageSize : Integer.MAX_VALUE;
        Sort.Direction sortDirection = Sort.Direction.fromOptionalString(direction).orElse(Sort.Direction.ASC);
        String sortProperty = resolveSortProperty(orderBy);
        return PageRequest.of(pageNumber, size, Sort.by(sortDirection, sortProperty));
    }

    private String resolveSortProperty(String orderBy) {
        if (!StringUtils.hasText(orderBy)) {
            return DEFAULT_SORT_PROPERTY;
        }
        String normalizedKey = orderBy.trim();
        String mappedProperty = SORT_PROPERTY_MAPPING.get(normalizedKey.toLowerCase(Locale.ROOT));
        if (mappedProperty != null) {
            return mappedProperty;
        }
        if (normalizedKey.contains(".")) {
            return normalizedKey;
        }
        return DEFAULT_SORT_PROPERTY;
    }

    private Page<Process> fetchProcesses(LocalDate startDate,
                                         LocalDate endDate,
                                         String state,
                                         String search,
                                         PageRequest pageRequest,
                                         boolean filterByProcessState) {
        LocalDate effectiveStart = startDate != null ? startDate : LocalDate.of(2000, 1, 1);
        LocalDate effectiveEnd = endDate != null ? endDate : LocalDate.now();
        if (effectiveStart.isAfter(effectiveEnd)) {
            LocalDate temp = effectiveStart;
            effectiveStart = effectiveEnd;
            effectiveEnd = temp;
        }
        String searchTerm = Optional.ofNullable(search).orElse("");

        if (!filterByProcessState) {
            return processRepository.findAllByStartDateBetweenAndUser_FullnameContainingIgnoreCase(effectiveStart, effectiveEnd, searchTerm, pageRequest);
        }

        String normalizedState = normalizeState(state);
        return switch (normalizedState) {
            case "COMPLETADO" ->
                    processRepository.findAllByStartDateBetweenAndFinishedIsTrueAndUser_FullnameContainingIgnoreCase(effectiveStart, effectiveEnd, searchTerm, pageRequest);
            case "PENDIENTE" ->
                    processRepository.findAllByStartDateBetweenAndFinishedIsFalseAndUser_FullnameContainingIgnoreCase(effectiveStart, effectiveEnd, searchTerm, pageRequest);
            case "DELAYED", "DELAYADO" ->
                    processRepository.findAllByStartDateBetweenAndDelayedIsTrueAndUser_FullnameContainingIgnoreCase(effectiveStart, effectiveEnd, searchTerm, pageRequest);
            default ->
                    processRepository.findAllByStartDateBetweenAndUser_FullnameContainingIgnoreCase(effectiveStart, effectiveEnd, searchTerm, pageRequest);
        };
    }

    private Map<Long, List<ProcessActivity>> loadActivities(List<Process> processes) {
        if (processes == null || processes.isEmpty()) {
            return Collections.emptyMap();
        }
        List<Long> processIds = processes.stream()
                .map(Process::getId)
                .filter(Objects::nonNull)
                .toList();
        if (processIds.isEmpty()) {
            return Collections.emptyMap();
        }
        List<ProcessActivity> activities = processActivityRepository.findByProcess_IdIn(processIds);
        return activities.stream()
                .filter(activity -> activity.getProcess() != null && activity.getProcess().getId() != null)
                .collect(Collectors.groupingBy(activity -> activity.getProcess().getId()));
    }

    private Map<Long, ProcessActivity> extractElearningActivities(Map<Long, List<ProcessActivity>> activitiesByProcess) {
        Map<Long, ProcessActivity> result = new HashMap<>();
        activitiesByProcess.forEach((processId, activities) -> {
            Optional<ProcessActivity> activityOptional = activities.stream()
                    .filter(activity -> activity.getActivity() != null && Constants.ACTIVITY_INDUCTION_ELEARNING.equals(activity.getActivity().getCode()))
                    .findFirst();
            activityOptional.ifPresent(processActivity -> result.put(processId, processActivity));
        });
        return result;
    }

    private Map<Long, List<ProcessActivityContent>> loadElearningContents(List<Process> processes) {
        if (processes == null || processes.isEmpty()) {
            return Collections.emptyMap();
        }
        List<Long> processIds = processes.stream()
                .map(Process::getId)
                .filter(Objects::nonNull)
                .toList();
        if (processIds.isEmpty()) {
            return Collections.emptyMap();
        }
        List<ProcessActivityContent> contents = processActivityContentRepository.findByProcessActivity_Process_IdIn(processIds);
        return contents.stream()
                .filter(content -> content.getProcessActivity() != null && content.getProcessActivity().getProcess() != null)
                .collect(Collectors.groupingBy(content -> content.getProcessActivity().getProcess().getId()));
    }

    private CardAggregation loadCardAggregation(List<Process> processes) {
        if (processes == null || processes.isEmpty()) {
            return new CardAggregation();
        }
        List<Long> processIds = processes.stream()
                .map(Process::getId)
                .filter(Objects::nonNull)
                .toList();
        return loadCardAggregationByProcessIds(processIds);
    }

    private CardAggregation loadCardAggregationByProcessIds(List<Long> processIds) {
        if (processIds == null || processIds.isEmpty()) {
            return new CardAggregation();
        }
        List<ProcessActivityContentCard> cards = processActivityContentCardRepository.findByProcessActivityContent_ProcessActivity_Process_IdIn(processIds);
        Map<Long, List<ProcessActivityContentCard>> cardsByContent = new HashMap<>();
        Map<Long, Long> readByProcess = new HashMap<>();
        Map<Long, Long> correctByProcess = new HashMap<>();
        Map<Long, Long> readByContent = new HashMap<>();
        Map<Long, Long> correctByContent = new HashMap<>();

        for (ProcessActivityContentCard card : cards) {
            if (card.getProcessActivityContent() == null || card.getProcessActivityContent().getProcessActivity() == null) {
                continue;
            }
            Process process = card.getProcessActivityContent().getProcessActivity().getProcess();
            if (process == null || process.getId() == null) {
                continue;
            }
            Long processId = process.getId();
            Long contentId = card.getProcessActivityContent().getId();
            cardsByContent.computeIfAbsent(contentId, key -> new ArrayList<>()).add(card);

            boolean read = card.getReadDateMobile() != null || card.getReadDateServer() != null;
            if (read) {
                readByProcess.merge(processId, 1L, Long::sum);
                readByContent.merge(contentId, 1L, Long::sum);
            }
            if (card.getAnswer() != null && card.getAnswer().isCorrect()) {
                correctByProcess.merge(processId, 1L, Long::sum);
                correctByContent.merge(contentId, 1L, Long::sum);
            }
        }

        return new CardAggregation(cardsByContent, readByProcess, correctByProcess, readByContent, correctByContent);
    }

    private ReportGeneralRowDTO buildGeneralRow(Process process, List<ProcessActivity> activities) {
        int totalActivities = activities.size();
        long completedActivities = activities.stream().filter(ProcessActivity::isCompleted).count();
        LocalDateTime finishDate = activities.stream()
                .filter(a -> a.getCompletionDate() != null && a.isCompleted())
                .count() == activities.size()
                ? activities.stream()
                .map(ProcessActivity::getCompletionDate)
                .filter(Objects::nonNull)
                .max(LocalDateTime::compareTo)
                .orElse(null)
                : null;
        double progress = totalActivities == 0 ? 0.0 : (completedActivities * 100.0) / totalActivities;

        String fullName = process.getUser() != null ? process.getUser().getFullname() : null;
        String dni = process.getUser() != null ? process.getUser().getDni() : null;
        boolean delayed = process.isDelayed();
        String state = process.isFinished() ? STATE_COMPLETED : STATE_PENDING;

        return ReportGeneralRowDTO.builder()
                .processId(process.getId())
                .fullName(fullName)
                .dni(dni)
                .delayed(delayed)
                .startDate(process.getStartDate())
                .finishDate(finishDate)
                .totalActivities(totalActivities)
                .completedActivities((int) completedActivities)
                .progress(progress)
                .state(state)
                .build();
    }

    private ReportElearningRowDTO buildElearningRow(Process process,
                                                    ProcessActivity elearningActivity,
                                                    List<ProcessActivityContent> contents) {
        Long processId = process.getId();
        boolean delayed = process.isDelayed();
        String dni = process.getUser() != null ? process.getUser().getDni() : null;
        String fullName = process.getUser() != null ? process.getUser().getFullname() : null;
        LocalDate startDate = process.getStartDate();
        LocalDateTime finishDate = elearningActivity != null ? elearningActivity.getCompletionDate() : null;

        double progress = contents.stream()
                .mapToInt(content -> Optional.ofNullable(content.getProgress()).orElse(0))
                .average()
                .orElse(0.0);

        boolean hasContents = !contents.isEmpty();
        boolean allCompleted = hasContents && contents.stream()
                .allMatch(content -> {
                    Integer progressValue = content.getProgress();
                    Integer resultValue = content.getResult();
                    return (progressValue != null && progressValue >= 100) || resultValue != null;
                });

        String state = allCompleted ? STATE_COMPLETED : STATE_PENDING;

        return ReportElearningRowDTO.builder()
                .processId(processId)
                .dni(dni)
                .fullName(fullName)
                .startDate(startDate)
                .finishDate(finishDate)
                .progress(progress)
                .state(state)
                .delayed(delayed)
                .build();
    }

    private ReportMatrixRowDTO buildMatrixRow(ReportGeneralRowDTO generalRow,
                                              ReportElearningRowDTO elearningRow,
                                              List<ProcessActivityContent> contents) {
        if (generalRow == null) {
            return ReportMatrixRowDTO.builder().build();
        }
        int generalCompleted = Optional.ofNullable(generalRow.getCompletedActivities()).orElse(0);
        int generalTotal = Optional.ofNullable(generalRow.getTotalActivities()).orElse(0);
        double elearningProgress = elearningRow != null ? elearningRow.getProgress() : 0.0;
        String elearningState = elearningRow != null ? elearningRow.getState() : STATE_PENDING;
        LocalDateTime elearningFinishDate = elearningRow != null ? elearningRow.getFinishDate() : null;

        List<ProcessActivityContent> safeContents = contents != null ? contents : Collections.emptyList();
        int elearningTotal = safeContents.size();
        int elearningCompleted = (int) safeContents.stream()
                .filter(content -> {
                    Integer progress = content.getProgress();
                    Integer result = content.getResult();
                    return (progress != null && progress >= 100) || result != null;
                })
                .count();

        Map<String, String> elearningResults = new LinkedHashMap<>();
        safeContents.forEach(content -> {
            String key;
            if (content.getContent() != null && StringUtils.hasText(content.getContent().getName())) {
                key = content.getContent().getName();
            } else {
                key = "Contenido " + Optional.ofNullable(content.getId()).map(String::valueOf).orElse("-");
            }
            String value = content.getResult() != null ? String.valueOf(content.getResult()) : "-";
            elearningResults.put(key, value);
        });

        return ReportMatrixRowDTO.builder()
                .processId(generalRow.getProcessId())
                .dni(generalRow.getDni())
                .fullName(generalRow.getFullName())
                .startDate(generalRow.getStartDate())
                .finishDate(generalRow.getFinishDate())
                .generalProgress(generalRow.getProgress())
                .generalCompletedActivities(generalCompleted)
                .generalTotalActivities(generalTotal)
                .generalState(generalRow.getState())
                .processState(generalRow.getState())
                .elearningProgress(elearningProgress)
                .elearningCompletedContents(elearningCompleted)
                .elearningTotalContents(elearningTotal)
                .elearningState(elearningState)
                .elearningFinishDate(elearningFinishDate)
                .elearningResults(elearningResults)
                .build();
    }
    private boolean filterElearningRow(ReportElearningRowDTO row, String normalizedState) {
        if (!StringUtils.hasText(normalizedState) || "ALL".equals(normalizedState)) {
            return true;
        }
        return filterByState(row.getState(), normalizedState);
    }

    private boolean filterByState(String state, String normalizedState) {
        if (!StringUtils.hasText(normalizedState) || "ALL".equals(normalizedState)) {
            return true;
        }
        if (!StringUtils.hasText(state)) {
            return false;
        }
        return state.equalsIgnoreCase(normalizedState);
    }

    private List<ReportElearningRowDTO> applyPagination(List<ReportElearningRowDTO> rows, Integer page, Integer pageSize) {
        return applyPaginationGeneric(rows, page, pageSize);
    }

    private <T> List<T> applyPaginationGeneric(List<T> rows, Integer page, Integer pageSize) {
        if (rows == null || rows.isEmpty()) {
            return Collections.emptyList();
        }
        int size = pageSize != null && pageSize > 0 ? pageSize : rows.size();
        int pageNumber = page != null && page >= 0 ? page : 0;
        int startIndex = pageNumber * size;
        if (startIndex >= rows.size()) {
            return Collections.emptyList();
        }
        int endIndex = Math.min(startIndex + size, rows.size());
        return new ArrayList<>(rows.subList(startIndex, endIndex));
    }

    private Comparator<ReportElearningRowDTO> buildElearningComparator(String orderBy, String direction) {
        Comparator<ReportElearningRowDTO> comparator;
        if ("progress".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparingDouble(ReportElearningRowDTO::getProgress);
        } else if ("finishDate".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportElearningRowDTO::getFinishDate, Comparator.nullsLast(LocalDateTime::compareTo));
        } else if ("startDate".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportElearningRowDTO::getStartDate, Comparator.nullsLast(LocalDate::compareTo));
        } else if ("dni".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportElearningRowDTO::getDni, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
        } else if ("state".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportElearningRowDTO::getState, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
        } else {
            comparator = Comparator.comparing(ReportElearningRowDTO::getFullName, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
        }
        if (Sort.Direction.DESC.name().equalsIgnoreCase(direction)) {
            comparator = comparator.reversed();
        }
        return comparator;
    }

    private Comparator<ReportActivityDetailDTO> buildActivityDetailComparator(String orderBy, String direction) {
        Comparator<ReportActivityDetailDTO> comparator;
        if ("completionDate".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportActivityDetailDTO::getCompletionDate, Comparator.nullsLast(LocalDateTime::compareTo));
        } else if ("state".equalsIgnoreCase(orderBy)) {
            comparator = Comparator.comparing(ReportActivityDetailDTO::getState, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
        } else {
            comparator = Comparator.comparing(ReportActivityDetailDTO::getActivityName, Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
        }
        if (Sort.Direction.DESC.name().equalsIgnoreCase(direction)) {
            comparator = comparator.reversed();
        }
        return comparator;
    }

    private String normalizeState(String state) {
        if (!StringUtils.hasText(state)) {
            return "ALL";
        }
        return state.trim().toUpperCase(Locale.getDefault());
    }

    private enum ReportType {
        GENERAL("general"),
        ELEARNING("elearning"),
        MATRIX("matrix");

        private final String value;

        ReportType(String value) {
            this.value = value;
        }

        static ReportType from(String value) {
            if (!StringUtils.hasText(value)) {
                return null;
            }
            for (ReportType type : values()) {
                if (type.value.equalsIgnoreCase(value)) {
                    return type;
                }
            }
            return null;
        }
    }

    private static class CardAggregation {
        private final Map<Long, List<ProcessActivityContentCard>> cardsByContent;
        private final Map<Long, Long> readByProcess;
        private final Map<Long, Long> correctByProcess;
        private final Map<Long, Long> readByContent;
        private final Map<Long, Long> correctByContent;

        CardAggregation() {
            this(new HashMap<>(), new HashMap<>(), new HashMap<>(), new HashMap<>(), new HashMap<>());
        }

        CardAggregation(Map<Long, List<ProcessActivityContentCard>> cardsByContent,
                        Map<Long, Long> readByProcess,
                        Map<Long, Long> correctByProcess,
                        Map<Long, Long> readByContent,
                        Map<Long, Long> correctByContent) {
            this.cardsByContent = cardsByContent;
            this.readByProcess = readByProcess;
            this.correctByProcess = correctByProcess;
            this.readByContent = readByContent;
            this.correctByContent = correctByContent;
        }

        Map<Long, List<ProcessActivityContentCard>> getCardsByContent() {
            return cardsByContent;
        }

        Map<Long, Long> getReadByProcess() {
            return readByProcess;
        }

        Map<Long, Long> getCorrectByProcess() {
            return correctByProcess;
        }

        Map<Long, Long> getReadByContent() {
            return readByContent;
        }

        Map<Long, Long> getCorrectByContent() {
            return correctByContent;
        }
    }
}
