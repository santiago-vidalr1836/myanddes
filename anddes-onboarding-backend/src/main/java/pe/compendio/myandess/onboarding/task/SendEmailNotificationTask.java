package pe.compendio.myandess.onboarding.task;

import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import pe.compendio.myandess.onboarding.entity.NotificationEmailTemplate;
import pe.compendio.myandess.onboarding.service.SenderNotificationEmailService;

@Component
@Slf4j
public class SendEmailNotificationTask {

    private final SenderNotificationEmailService senderNotificationEmailService;

    public SendEmailNotificationTask(SenderNotificationEmailService senderNotificationEmailService) {
        this.senderNotificationEmailService = senderNotificationEmailService;
    }

    /**
     * Este cron se ejecuta cada 2 horas.
     */
    @Scheduled(cron = "0 0 */2 * * ?")
    public void startEmailNotificationOnboarding() throws Exception {
        log.info("startEmailNotificationOnboarding...");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.ONBOARDING)
                .forEach(senderNotificationEmailService::sendEmailOnboarding);
    }

    /**
     * Este cron se ejecuta cada día a las 7 am.
     */
    @Scheduled(cron = "0 0 7 * * *")
    public void startEmailNotificationFirstDayAndElearningStart() throws Exception {
        log.info("startEmailNotificationFirstDay...");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.FIRST_DAY)
                .forEach(senderNotificationEmailService::sendEmailFirstDay);

        log.info("startEmailNotificationELearningStart..");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.ELEARNING_START)
                .forEach(senderNotificationEmailService::sendEmailElearningStart);
    }

    /**
     * Este cron se ejecuta cada día a las 12 pm.
     */
    //@Scheduled(cron = "*/5 * * * * *")
    @Scheduled(cron = "0 0 12 * * *")
    public void startEmailNotificationInProgressAndFinishAndRemind() throws Exception {
        log.info("startEmailNotificationInProgress...");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.ELEARNING_INPROGRESS)
                .forEach(senderNotificationEmailService::sendEmailElearningInProgressAndFinishAndRemind);

        log.info("startEmailNotificationFinish..");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.ELEARNING_FINISH)
                .forEach(senderNotificationEmailService::sendEmailElearningInProgressAndFinishAndRemind);

        log.info("startEmailNotificationRemind..");
        senderNotificationEmailService.listNotificationsPending(NotificationEmailTemplate.ELEARNING_REMIND)
                .forEach(senderNotificationEmailService::sendEmailElearningInProgressAndFinishAndRemind);
    }
}
