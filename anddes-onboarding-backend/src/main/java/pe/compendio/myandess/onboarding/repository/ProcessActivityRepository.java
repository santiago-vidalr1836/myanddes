package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivity;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcessActivityRepository extends CrudRepository<ProcessActivity,Long> {
    List<ProcessActivity> findByProcess_Id(Long processId);

    @Query(" SELECT pa " +
          " FROM ProcessActivity pa " +
          " JOIN pa.process p " +
          " JOIN pa.activity a " +
          " WHERE a.code = :codActivity " +
          " and pa.completed = TRUE " +
          " and p.startDate between :startDate and :endDate ")
    List<ProcessActivity> findByProcessInductionELearningFinished(String codActivity, LocalDate startDate, LocalDate endDate);

    Optional<ProcessActivity> findFirstByProcess_IdAndActivity_Code(Long processId, String activityCode);
}
