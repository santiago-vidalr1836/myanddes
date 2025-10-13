package pe.compendio.myandess.onboarding.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pe.compendio.myandess.onboarding.controller.dto.NotificationEmailTemplateDTO;
import pe.compendio.myandess.onboarding.controller.dto.NotificationSenderProfileDTO;
import pe.compendio.myandess.onboarding.controller.dto.SendEmailDTO;
import pe.compendio.myandess.onboarding.service.NotificationService;
import pe.compendio.myandess.onboarding.service.SmtpService;
import pe.compendio.myandess.onboarding.util.Mapper;

import java.util.List;

@RestController
@RequestMapping(path = "/notification")
public class NotificationController {

    Mapper mapper;
    NotificationService notificationService;
    SmtpService smtpService;

    public NotificationController(Mapper mapper, NotificationService notificationService, SmtpService smtpService) {
        this.mapper = mapper;
        this.notificationService = notificationService;
        this.smtpService = smtpService;
    }

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
            @PathVariable String templateId) {
        return mapper.notificationEmailTemplateEntityToDTO(notificationService.getEmailTemplate(templateId));
    }

    @PutMapping("/templates/{templateId}")
    public ResponseEntity<?> updateEmailTemplate(
            @PathVariable String templateId,
            @RequestBody NotificationEmailTemplateDTO dto) {
        dto.setId(templateId);
        notificationService.updateEmailTemplate(mapper.notificationEmailTemplateDTOToEntity(dto));
        return ResponseEntity.ok().build();
    }

/*    @PostMapping("/push")
    public ResponseEntity<?> sendEmail(@RequestBody SendEmailDTO dto) {
        this.smtpService.send(dto.getTo(), dto.getSubject(), dto.getBody());
        return ResponseEntity.ok().build();
    }*/

}
