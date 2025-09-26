package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.OnSiteInduction;

@Repository
public interface OnSiteInductionRepository extends CrudRepository<OnSiteInduction,Long> {
}
