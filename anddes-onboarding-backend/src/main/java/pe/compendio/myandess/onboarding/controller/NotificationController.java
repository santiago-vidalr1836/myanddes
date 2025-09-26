package pe.compendio.myandess.onboarding.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.NotificationEmailTemplateDTO;
import pe.compendio.myandess.onboarding.controller.dto.NotificationSenderProfileDTO;
import pe.compendio.myandess.onboarding.service.NotificationService;
import pe.compendio.myandess.onboarding.service.ProcessService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/notification")
public class NotificationController {
    @Autowired
    Mapper mapper;
    @Autowired
    NotificationService notificationService;

    @GetMapping("/profile")
    public List<NotificationSenderProfileDTO> listNotificationProfile() {
        return mapper.notificationSenderProfileEntityToDTOs(notificationService.listSenderProfile());
    }

    @PutMapping("/profile/{fieldId}")
    public ResponseEntity<?> updateNotificationProfile(
            @PathVariable Long fieldId,
            @RequestBody NotificationSenderProfileDTO dto) {
        dto.setId(fieldId);
        notificationService.updateSenderProfile(mapper.notificationSenderProfileDTOToEntity(dto));
        return ResponseEntity.ok().build();
    }

//    @GetMapping("/templates")
//    public List<NotificationEmailTemplateDTO> listEmailTemplates() {
//        return mapper.notificationEmailTemplateEntityToDTOs(notificationService.listEmailTemplate());
//    }

    @GetMapping("/templates/{templateId}")
    public NotificationEmailTemplateDTO updateEmailTemplate(
            @PathVariable Long templateId) {
        return mapper.notificationEmailTemplateEntityToDTO(notificationService.getEmailTemplate(templateId));
    }

    @PutMapping("/templates/{templateId}")
    public ResponseEntity<?> updateEmailTemplate(
            @PathVariable Long templateId,
            @RequestBody NotificationEmailTemplateDTO dto) {
        dto.setId(templateId);
        notificationService.updateEmailTemplate(mapper.notificationEmailTemplateDTOToEntity(dto));
        return ResponseEntity.ok().build();
    }

}
