package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ELearningContent;

import java.util.List;

@Repository
public interface ELearningContentRepository extends JpaRepository<ELearningContent,Long> {
  List<ELearningContent> findAllByOrderByPositionAsc();
}
