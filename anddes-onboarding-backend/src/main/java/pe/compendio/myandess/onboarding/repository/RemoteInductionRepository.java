package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.RemoteInduction;

@Repository
public interface RemoteInductionRepository extends CrudRepository<RemoteInduction,Long> {

}
