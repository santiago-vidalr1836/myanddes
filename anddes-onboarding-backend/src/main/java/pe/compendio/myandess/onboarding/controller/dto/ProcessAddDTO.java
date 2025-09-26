package pe.compendio.myandess.onboarding.controller.dto;


import lombok.Data;

import java.time.LocalDate;

@Data
public class ProcessAddDTO {
  private Long userId;
  private LocalDate startDate;

  private String hourOnsite;
  private String placeOnsite;
  private String hourRemote;
  private String linkRemote;
}
