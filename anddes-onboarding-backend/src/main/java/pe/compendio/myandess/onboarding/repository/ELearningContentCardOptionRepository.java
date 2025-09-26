package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ELearningContentCardOption;

@Repository
public interface ELearningContentCardOptionRepository extends CrudRepository<ELearningContentCardOption,Long> {
}
