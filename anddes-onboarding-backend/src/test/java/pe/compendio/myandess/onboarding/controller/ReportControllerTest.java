package pe.compendio.myandess.onboarding.controller;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.compendio.myandess.onboarding.controller.dto.ReportElearningDetailDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportGeneralRowDTO;
import pe.compendio.myandess.onboarding.controller.dto.ReportPagedDTO;
import pe.compendio.myandess.onboarding.service.ReportService;

import java.time.LocalDate;
import java.util.List;

import static org.hamcrest.Matchers.containsString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.nullable;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(controllers = ReportController.class)
@AutoConfigureMockMvc(addFilters = false)
class ReportControllerTest {

  @Autowired
  private MockMvc mockMvc;

  @MockBean
  private ReportService reportService;

  @Test
  void generalReportEndpointShouldReturnData() throws Exception {
    ReportGeneralRowDTO row = ReportGeneralRowDTO.builder()
      .processId(1L)
      .collaborator("Ana Diaz")
      .totalActivities(5)
      .completedActivities(3)
      .progress(60.0)
      .state("Pendiente")
      .build();
    ReportPagedDTO<ReportGeneralRowDTO> paged = new ReportPagedDTO<>(1, List.of(row));

    when(reportService.getGeneralReport(any(LocalDate.class), any(LocalDate.class), nullable(String.class), nullable(String.class), anyInt(), anyInt(), anyString(), anyString()))
      .thenReturn(paged);

    mockMvc.perform(get("/reports/general")
        .param("startDate", "2024-01-01")
        .param("endDate", "2024-12-31"))
      .andExpect(status().isOk())
      .andExpect(jsonPath("$.total").value(1))
      .andExpect(jsonPath("$.items[0].collaborator").value("Ana Diaz"));
  }

  @Test
  void elearningDetailsEndpointShouldReturnCourses() throws Exception {
    ReportElearningDetailDTO detail = ReportElearningDetailDTO.builder()
      .contentId(10L)
      .courseName("Seguridad")
      .state("Pendiente")
      .build();
    when(reportService.getElearningDetails(anyLong(), any(LocalDate.class), any(LocalDate.class), nullable(String.class), nullable(String.class), anyString(), anyString()))
      .thenReturn(List.of(detail));

    mockMvc.perform(get("/reports/elearning/1/courses"))
      .andExpect(status().isOk())
      .andExpect(jsonPath("$[0].courseName").value("Seguridad"));
  }

  @Test
  void downloadShouldReturnExcelFile() throws Exception {
    when(reportService.buildWorkbook(anyString(), any(LocalDate.class), any(LocalDate.class), nullable(String.class), nullable(String.class), anyString(), anyString()))
      .thenReturn(new XSSFWorkbook());

    mockMvc.perform(get("/reports/general/download"))
      .andExpect(status().isOk())
      .andExpect(header().string("Content-Disposition", containsString("report-general")))
      .andExpect(content().contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")));
  }
}
