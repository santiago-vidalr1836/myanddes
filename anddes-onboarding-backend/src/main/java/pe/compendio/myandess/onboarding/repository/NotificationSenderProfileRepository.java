package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.File;
import pe.compendio.myandess.onboarding.entity.NotificationSenderProfile;

@Repository
public interface NotificationSenderProfileRepository extends CrudRepository<NotificationSenderProfile, Long> {
}
