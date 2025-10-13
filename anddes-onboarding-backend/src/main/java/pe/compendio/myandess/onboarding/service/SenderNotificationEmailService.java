package pe.compendio.myandess.onboarding.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import pe.compendio.myandess.onboarding.entity.*;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.repository.*;
import pe.compendio.myandess.onboarding.template.TemplateParamsBuilder;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@Slf4j
public class SenderNotificationEmailService {

    private final TemplateService templateService;
    private final SmtpService smtpService;
    private final ScheduledEmailNotificationRepository scheduledEmailNotificationRepository;
    private final ProcessRepository processRepository;
    private final NotificationSenderProfileRepository notificationSenderProfileRepository;
    private final NotificationEmailTemplateRepository notificationEmailTemplateRepository;
    private final ProcessActivityRepository processActivityRepository;
    private final ELearningContentRepository eLearningContentRepository;
    private final ProcessActivityContentRepository processActivityContentRepository;


    public SenderNotificationEmailService(TemplateService templateService, SmtpService smtpService, ScheduledEmailNotificationRepository scheduledEmailNotificationRepository, ProcessRepository processRepository, NotificationSenderProfileRepository notificationSenderProfileRepository, NotificationEmailTemplateRepository notificationEmailTemplateRepository, ProcessActivityRepository processActivityRepository, ELearningContentRepository eLearningContentRepository, ProcessActivityContentRepository processActivityContentRepository) {
        this.templateService = templateService;
        this.smtpService = smtpService;
        this.scheduledEmailNotificationRepository = scheduledEmailNotificationRepository;
        this.processRepository = processRepository;
        this.notificationSenderProfileRepository = notificationSenderProfileRepository;
        this.notificationEmailTemplateRepository = notificationEmailTemplateRepository;
        this.processActivityRepository = processActivityRepository;
        this.eLearningContentRepository = eLearningContentRepository;
        this.processActivityContentRepository = processActivityContentRepository;
    }

    public List<ScheduledEmailNotification> listNotificationsPending(final String templateId) {
        Date today = Date.from(LocalDate.now().atStartOfDay(ZoneId.systemDefault()).toInstant());
        return this.scheduledEmailNotificationRepository.findByNotificationEmailTemplate_IdAndScheduledDateAndStatus(
                templateId, today, "PENDING"
        );
    }

    public void sendEmailOnboarding(ScheduledEmailNotification notification) {
        log.info("sendEmailOnboarding...");
        Process process = this.processRepository.findByUser_Id(notification.getUser().getId()).orElse(null);
        assert process != null;

        TemplateParamsBuilder paramsBuilder = new TemplateParamsBuilder()
                .setStartDateOnboarding(this.formatDate(process.getStartDate()))
                .setEndDateOnboarding(this.formatDate(process.getStartDate().plusDays(7)));

        this.sendEmail(notification.getUser(), notification, paramsBuilder);
    }

    public void sendEmailFirstDay(ScheduledEmailNotification notification) {
        log.info("sendEmailFirstDay...");
        this.sendEmail(notification.getUser(), notification, new TemplateParamsBuilder());
    }

    public void sendEmailElearningStart(ScheduledEmailNotification notification) {
        log.info("sendEmailElearningStart...");
        Process process = this.processRepository.findByUser_Id(notification.getUser().getId()).orElse(null);
        if (process == null) return;

        TemplateParamsBuilder paramsBuilder = new TemplateParamsBuilder()
                .setEndDateOnboarding(this.formatDate(process.getStartDate().plusDays(7)));

        this.sendEmail(notification.getUser(), notification, paramsBuilder);
    }

    public void sendEmailElearningInProgressAndFinishAndRemind(ScheduledEmailNotification notification) {
        log.info("sendEmailElearningInProgressAndFinishAndRemind...");
        Process process = this.processRepository.findByUser_Id(notification.getUser().getId()).orElse(null);
        assert process != null;

        ProcessActivity processActivity = this.processActivityRepository.findFirstByProcess_IdAndActivity_Code(process.getId(), "INDUCTION_ELEARNING").orElse(null);
        if (processActivity == null || processActivity.isCompleted()) return;

        long totalELearningContents = this.eLearningContentRepository.count();
        long totalProcessActivityContents = this.processActivityContentRepository.countByProcessActivity_IdAndStatus(processActivity.getId(), "SUCCESSFUL");
        TemplateParamsBuilder paramsBuilder = new TemplateParamsBuilder();
        paramsBuilder.setTotalCourses(String.valueOf(totalELearningContents))
                .setTotalCoursesCompleted(String.valueOf(totalProcessActivityContents));

        this.sendEmail(notification.getUser(), notification, paramsBuilder);
    }

    protected void sendEmail(User user, ScheduledEmailNotification notification, TemplateParamsBuilder paramsBuilder) {
        NotificationEmailTemplate base = this.notificationEmailTemplateRepository.findById(NotificationEmailTemplate.BASE_TEMPLATE).orElse(null);
        assert base != null;
        String baseTemplate = base.getBodyTemplate().replace(TemplateParamsBuilder.EMAIL_CONTENT_KEY, notification.getNotificationEmailTemplate().getBodyTemplate());

        List<NotificationSenderProfile> profile = (List<NotificationSenderProfile>) this.notificationSenderProfileRepository.findAll();

        Map<String, String> params = paramsBuilder
                .setEmployeeName(user.getFullname())
                .setAddress(profile.get(0).getAddress())
                .setProfilePhoto(profile.get(0).getUrlPhoto())
                .setProfileName(profile.get(0).getFullname())
                .setProfilePosition(profile.get(0).getPosition())
                .build();

        String body = this.templateService.render(baseTemplate, params);
        boolean result = this.smtpService.send(user.getEmail(), notification.getNotificationEmailTemplate().getSubject(), body);

        if (result) this.markAsSent(notification);
    }

    protected String formatDate(LocalDate date) {
        DateTimeFormatter customFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        return date.format(customFormatter);
    }

    protected void markAsSent(ScheduledEmailNotification notification) {
        notification.setStatus("SENT");
        notification.setDispatchDate(new Date());
        this.scheduledEmailNotificationRepository.save(notification);
    }

}
