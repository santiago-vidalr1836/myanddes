package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ScheduledEmailNotification;

import java.util.Date;
import java.util.List;

@Repository
public interface ScheduledEmailNotificationRepository extends CrudRepository<ScheduledEmailNotification, Long> {

    List<ScheduledEmailNotification> findByNotificationEmailTemplate_IdAndScheduledDateBetweenAndStatus(
            String templateId,
            Date startDate,
            Date endDate,
            String status);

    List<ScheduledEmailNotification> findByNotificationEmailTemplate_IdAndScheduledDateAndStatus(
            String templateId,
            Date today,
            String status);

}
