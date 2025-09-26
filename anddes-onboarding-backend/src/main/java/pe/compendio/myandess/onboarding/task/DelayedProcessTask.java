package pe.compendio.myandess.onboarding.task;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import pe.compendio.myandess.onboarding.service.ProcessService;

import java.time.LocalDate;

@Component
public class DelayedProcessTask {
  @Autowired
  ProcessService processService;

  @Scheduled(cron = "0 23 * * *")
  public void startDelayedProcessByCron() throws Exception {
    var dateOfLastWeek = LocalDate.now().minusDays((7+1));
    processService
      .findByStartDateBeforeAndFinishedIsFalseAndDelayedIsFalse(dateOfLastWeek)
      .forEach(processService::updateProcessDelayed);
  }
}
