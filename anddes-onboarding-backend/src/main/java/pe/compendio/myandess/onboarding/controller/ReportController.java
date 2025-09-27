package pe.compendio.myandess.onboarding.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import pe.compendio.myandess.onboarding.controller.dto.ReportActivityDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportGeneralRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportMatrixRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportPagedDTO;
import pe.compendio.myandess.onboarding.service.ReportService;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Year;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
public class ReportController {

  private final ReportService reportService;
  private static final DateTimeFormatter FILE_TIMESTAMP = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");

  @Operation(summary = "Reporte general paginado")
  @GetMapping("/general")
  public ReportPagedDTO<ReportGeneralRowDTO> getGeneralReport(@RequestParam(required = false) String startDate,
                                                              @RequestParam(required = false) String endDate,
                                                              @RequestParam(required = false) String period,
                                                              @RequestParam(required = false) String state,
                                                              @RequestParam(required = false) String search,
                                                              @RequestParam(defaultValue = "0") Integer page,
                                                              @RequestParam(defaultValue = "20") Integer pageSize,
                                                              @RequestParam(defaultValue = "user.fullname") String orderBy,
                                                              @RequestParam(defaultValue = "asc") String direction) {
    DateRange range = resolveDateRange(startDate, endDate, period);
    return reportService.getGeneralReport(range.start(), range.end(), state, search, page, pageSize, orderBy, direction);
  }

  @Operation(summary = "Reporte de e-learning paginado")
  @GetMapping("/elearning")
  public ReportPagedDTO<ReportElearningRowDTO> getElearningReport(@RequestParam(required = false) String startDate,
                                                                  @RequestParam(required = false) String endDate,
                                                                  @RequestParam(required = false) String period,
                                                                  @RequestParam(required = false) String state,
                                                                  @RequestParam(required = false) String search,
                                                                  @RequestParam(defaultValue = "0") Integer page,
                                                                  @RequestParam(defaultValue = "20") Integer pageSize,
                                                                  @RequestParam(defaultValue = "user.fullname") String orderBy,
                                                                  @RequestParam(defaultValue = "asc") String direction) {
    DateRange range = resolveDateRange(startDate, endDate, period);
    return reportService.getElearningReport(range.start(), range.end(), state, search, page, pageSize, orderBy, direction);
  }

  @Operation(summary = "Reporte matriz paginado")
  @GetMapping("/matrix")
  public ReportPagedDTO<ReportMatrixRowDTO> getMatrixReport(@RequestParam(required = false) String startDate,
                                                            @RequestParam(required = false) String endDate,
                                                            @RequestParam(required = false) String period,
                                                            @RequestParam(required = false) String state,
                                                            @RequestParam(required = false) String search,
                                                            @RequestParam(defaultValue = "0") Integer page,
                                                            @RequestParam(defaultValue = "20") Integer pageSize,
                                                            @RequestParam(defaultValue = "user.fullname") String orderBy,
                                                            @RequestParam(defaultValue = "asc") String direction) {
    DateRange range = resolveDateRange(startDate, endDate, period);
    return reportService.getMatrixReport(range.start(), range.end(), state, search, page, pageSize, orderBy, direction);
  }

  @Operation(summary = "Detalle de actividades del proceso")
  @GetMapping("/general/{processId}/activities")
  public List<ReportActivityDetailDTO> getGeneralDetails(@PathVariable Long processId,
                                                         @RequestParam(required = false) String startDate,
                                                         @RequestParam(required = false) String endDate,
                                                         @RequestParam(required = false) String period,
                                                         @RequestParam(required = false) String state,
                                                         @RequestParam(required = false) String search,
                                                         @RequestParam(defaultValue = "activityName") String orderBy,
                                                         @RequestParam(defaultValue = "asc") String direction) {
    return reportService.getGeneralDetails(processId, state, search, orderBy, direction);
  }

  @Operation(summary = "Detalle de cursos e-learning del proceso")
  @GetMapping("/elearning/{processId}/courses")
  public List<ReportElearningDetailDTO> getElearningDetails(@PathVariable Long processId) {
    return reportService.getElearningDetails(processId);
  }

  @Operation(summary = "Descargar reporte en Excel")
  @GetMapping("/{type}/download")
  public ResponseEntity<byte[]> downloadReport(@PathVariable String type,
                                               @RequestParam(required = false) String startDate,
                                               @RequestParam(required = false) String endDate,
                                               @RequestParam(required = false) String period,
                                               @RequestParam(required = false) String state,
                                               @RequestParam(required = false) String search,
                                               @RequestParam(defaultValue = "user.fullname") String orderBy,
                                               @RequestParam(defaultValue = "asc") String direction) {
    DateRange range = resolveDateRange(startDate, endDate, period);
    Workbook workbook;
    try {
      workbook = reportService.buildWorkbook(type, range.start(), range.end(), state, search, orderBy, direction);
    } catch (IllegalArgumentException ex) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, ex.getMessage(), ex);
    }

    try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
      workbook.write(outputStream);
      workbook.close();

      HttpHeaders headers = new HttpHeaders();
      headers.setContentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
      ContentDisposition disposition = ContentDisposition.attachment()
        .filename(String.format("report-%s-%s.xlsx", type.toLowerCase(), LocalDateTime.now().format(FILE_TIMESTAMP)))
        .build();
      headers.setContentDisposition(disposition);

      return ResponseEntity.ok()
        .headers(headers)
        .body(outputStream.toByteArray());
    } catch (IOException e) {
      throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "No se pudo generar el archivo", e);
    }
  }

  private DateRange resolveDateRange(String startDate, String endDate, String period) {
    LocalDate start = null;
    LocalDate end = null;

    if (StringUtils.hasText(period)) {
      period = period.trim();
      try {
        if ("3m".equalsIgnoreCase(period)) {
          LocalDate today = LocalDate.now();
          start = today.minusMonths(3);
          end = today;
        } else if ("1m".equalsIgnoreCase(period)) {
          LocalDate today = LocalDate.now();
          start = today.minusMonths(1);
          end = today;
        } else if ("custom".equalsIgnoreCase(period)) {
          if (!StringUtils.hasText(startDate) || !StringUtils.hasText(endDate)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Fechas requeridas para periodo personalizado");
          }
          start = LocalDate.parse(startDate.trim());
          end = LocalDate.parse(endDate.trim());
        } else if (period.matches("\\d{4}-\\d{2}")) {
          YearMonth yearMonth = YearMonth.parse(period);
          start = yearMonth.atDay(1);
          end = yearMonth.atEndOfMonth();
        } else if (period.matches("\\d{4}")) {
          Year year = Year.parse(period);
          start = year.atDay(1);
          end = year.atMonth(12).atEndOfMonth();
        }
      } catch (Exception ex) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Periodo inválido", ex);
      }
    }

    try {
      if (start == null && StringUtils.hasText(startDate)) {
        start = LocalDate.parse(startDate.trim());
      }
      if (end == null && StringUtils.hasText(endDate)) {
        end = LocalDate.parse(endDate.trim());
      }
    } catch (Exception ex) {
      throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Fechas inválidas", ex);
    }

    if (start == null) {
      start = LocalDate.of(2000, 1, 1);
    }
    if (end == null) {
      end = LocalDate.now();
    }
    if (start.isAfter(end)) {
      LocalDate temp = start;
      start = end;
      end = temp;
    }

    return new DateRange(start, end);
  }

  private record DateRange(LocalDate start, LocalDate end) { }
}
