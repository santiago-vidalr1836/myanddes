package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.NotificationEmailTemplate;
import pe.compendio.myandess.onboarding.entity.NotificationSenderProfile;

@Repository
public interface NotificationEmailTemplateRepository extends CrudRepository<NotificationEmailTemplate, Long> {
}
