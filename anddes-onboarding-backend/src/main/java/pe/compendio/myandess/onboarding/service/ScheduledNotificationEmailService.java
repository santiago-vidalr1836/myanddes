package pe.compendio.myandess.onboarding.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import pe.compendio.myandess.onboarding.entity.*;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.repository.NotificationEmailTemplateRepository;
import pe.compendio.myandess.onboarding.repository.NotificationSenderProfileRepository;
import pe.compendio.myandess.onboarding.repository.ScheduledEmailNotificationRepository;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

@Slf4j
@Service
public class ScheduledNotificationEmailService {

    private final ScheduledEmailNotificationRepository scheduledEmailNotificationRepository;
    private final NotificationEmailTemplateRepository notificationEmailTemplateRepository;
    private final NotificationSenderProfileRepository notificationSenderProfileRepository;

    public ScheduledNotificationEmailService(
            NotificationSenderProfileRepository notificationSenderProfileRepository,
            NotificationEmailTemplateRepository notificationEmailTemplateRepository,
            ScheduledEmailNotificationRepository scheduledEmailNotificationRepository) {
        this.notificationSenderProfileRepository = notificationSenderProfileRepository;
        this.notificationEmailTemplateRepository = notificationEmailTemplateRepository;
        this.scheduledEmailNotificationRepository = scheduledEmailNotificationRepository;
    }

    public void scheduleEmailOnboardingAndInProgressAndFinish(Process process) {
        LocalDate today1 = LocalDate.now();
        Date today = Date.from(today1.atStartOfDay(ZoneId.systemDefault()).toInstant());

        LocalDate after4Days1 = process.getStartDate().plusDays(4);
        Date after4Days = Date.from(after4Days1.atStartOfDay(ZoneId.systemDefault()).toInstant());

        LocalDate after7Days1 = process.getStartDate().plusDays(7);
        Date after7Days = Date.from(after7Days1.atStartOfDay(ZoneId.systemDefault()).toInstant());

        this.scheduleEmail(process.getUser(), today, NotificationEmailTemplate.ONBOARDING);
        this.scheduleEmail(process.getUser(), after4Days, NotificationEmailTemplate.ELEARNING_INPROGRESS);
        this.scheduleEmail(process.getUser(), after7Days, NotificationEmailTemplate.ELEARNING_FINISH);
    }

    public void scheduleEmailFirstDayAndElearningStart(Process process) {
        Date scheduleDate = Date.from(process.getStartDate().atStartOfDay(ZoneId.systemDefault()).toInstant());
        this.scheduleEmail(process.getUser(), scheduleDate, NotificationEmailTemplate.FIRST_DAY);
        this.scheduleEmail(process.getUser(), scheduleDate, NotificationEmailTemplate.ELEARNING_START);
    }

    public void scheduleEmailRemind(Process process) {
        List<NotificationSenderProfile> profile = (List<NotificationSenderProfile>) this.notificationSenderProfileRepository.findAll();

        LocalDate finishDate = process.getStartDate().plusDays(7);
        for (int i = 0; i < profile.get(0).getRemindersNumber(); i++) {
            finishDate = finishDate.plusDays(3);
            Date scheduleDate = Date.from(finishDate.atStartOfDay(ZoneId.systemDefault()).toInstant());
            this.scheduleEmail(process.getUser(), scheduleDate, NotificationEmailTemplate.ELEARNING_REMIND);
        }
    }

    private void scheduleEmail(User user, Date scheduleDate, String templateId) {
        NotificationEmailTemplate template = this.notificationEmailTemplateRepository.findById(templateId).orElse(null);

        ScheduledEmailNotification schedule = new ScheduledEmailNotification();
        schedule.setStatus("PENDING");
        schedule.setUser(user);
        schedule.setCreatedAt(new Date());
        schedule.setNotificationEmailTemplate(template);
        schedule.setScheduledDate(scheduleDate);

        this.scheduledEmailNotificationRepository.save(schedule);
    }


}
