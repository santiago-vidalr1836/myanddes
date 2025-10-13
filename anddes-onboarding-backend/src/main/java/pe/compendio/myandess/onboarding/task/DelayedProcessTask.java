package pe.compendio.myandess.onboarding.task;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import pe.compendio.myandess.onboarding.entity.Process;
import pe.compendio.myandess.onboarding.service.ProcessService;
import pe.compendio.myandess.onboarding.service.ScheduledNotificationEmailService;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Component
public class DelayedProcessTask {
    @Autowired
    ProcessService processService;
    @Autowired
    ScheduledNotificationEmailService scheduledNotificationEmailService;

    @Scheduled(cron = "0 23 * * * ?")
    public void startDelayedProcessByCron() throws Exception {
        log.info("startDelayedProcessByCron...");
        var dateOfLastWeek = LocalDate.now().minusDays((7 + 1));

        List<Process> process = processService
                .findByStartDateBeforeAndFinishedIsFalseAndDelayedIsFalse(dateOfLastWeek);

        process.forEach(processService::updateProcessDelayed);
        process.forEach(scheduledNotificationEmailService::scheduleEmailRemind);
    }
}
