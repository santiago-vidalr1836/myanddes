package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.Activity;

import java.util.List;

@Repository
public interface ActivityRepository extends CrudRepository<Activity,Long> {
  List<Activity> findByParentCodeOrderByIdAsc(String parentCode);
}
