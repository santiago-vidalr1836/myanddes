package pe.compendio.myandess.onboarding.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import pe.compendio.myandess.onboarding.entity.NotificationEmailTemplate;
import pe.compendio.myandess.onboarding.entity.NotificationSenderProfile;
import pe.compendio.myandess.onboarding.repository.NotificationEmailTemplateRepository;
import pe.compendio.myandess.onboarding.repository.NotificationSenderProfileRepository;

import java.util.List;

@Component
public class NotificationService {

    @Autowired
    NotificationSenderProfileRepository notificationSenderProfileRepository;
    @Autowired
    NotificationEmailTemplateRepository notificationEmailTemplateRepository;

    public List<NotificationSenderProfile> listSenderProfile() {
        return (List<NotificationSenderProfile>) notificationSenderProfileRepository.findAll();
    }

    public NotificationSenderProfile updateSenderProfile(NotificationSenderProfile notificationSenderProfile) {
        var optional = notificationSenderProfileRepository.findById(notificationSenderProfile.getId());
        if (optional.isPresent()) {
            var toUpdate = optional.get();
            toUpdate.setFullname(notificationSenderProfile.getFullname());
            toUpdate.setPosition(notificationSenderProfile.getPosition());
            toUpdate.setAddress(notificationSenderProfile.getAddress());
            toUpdate.setUrlPhoto(notificationSenderProfile.getUrlPhoto());
            return notificationSenderProfileRepository.save(toUpdate);
        } else return null;
    }

    public List<NotificationEmailTemplate> listEmailTemplate() {
        return (List<NotificationEmailTemplate>) notificationEmailTemplateRepository.findAll();
    }

    public NotificationEmailTemplate getEmailTemplate(Long templateId) {
        var optional = notificationEmailTemplateRepository.findById(templateId);
        return optional.orElse(null);
    }

    public NotificationEmailTemplate updateEmailTemplate(NotificationEmailTemplate notificationEmailTemplate) {
        var optional = notificationEmailTemplateRepository.findById(notificationEmailTemplate.getId());
        if (optional.isPresent()) {
            var toUpdate = optional.get();
            toUpdate.setSubject(notificationEmailTemplate.getSubject());
            toUpdate.setBodyTemplate(notificationEmailTemplate.getBodyTemplate());
            toUpdate.setAdditionalMessage(notificationEmailTemplate.getAdditionalMessage());
            return notificationEmailTemplateRepository.save(toUpdate);
        } else return null;
    }

}
