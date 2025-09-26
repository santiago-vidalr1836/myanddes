package pe.compendio.myandess.onboarding.controller.dto;

import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
public class ServiceDTO {
    private Long id;
    private String name;
    private String description;
    private String icon;
    private String iconWeb;
    private List<ServiceDetailDTO> details;
    private Integer position;
}
