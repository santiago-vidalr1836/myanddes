package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivity;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcessActivityRepository extends JpaRepository<ProcessActivity,Long> {
    List<ProcessActivity> findByProcess_Id(Long processId);

    List<ProcessActivity> findByProcess_IdIn(List<Long> processIds);

    List<ProcessActivity> findByActivity_CodeAndProcess_IdIn(String activityCode, List<Long> processIds);

    @Query(" SELECT pa " +
          " FROM ProcessActivity pa " +
          " JOIN pa.process p " +
          " JOIN pa.activity a " +
          " WHERE a.code = :codActivity " +
          " and pa.completed = TRUE " +
          " and p.startDate between :startDate and :endDate ")
    List<ProcessActivity> findByProcessInductionELearningFinished(String codActivity, LocalDate startDate, LocalDate endDate);

    Optional<ProcessActivity> findFirstByProcess_IdAndActivity_Code(Long processId, String activityCode);

    Optional<ProcessActivity> findByProcess_IdAndActivity_Code(Long processId, String activityCode);

    Page<ProcessActivity> findAllByActivity_CodeAndProcess_StartDateBetween(String activityCode,
                                                                           LocalDate startDate,
                                                                           LocalDate endDate,
                                                                           Pageable pageable);

    Page<ProcessActivity> findAllByActivity_CodeAndProcess_StartDateBetweenAndCompletedIsTrue(String activityCode,
                                                                                             LocalDate startDate,
                                                                                             LocalDate endDate,
                                                                                             Pageable pageable);

    Page<ProcessActivity> findAllByActivity_CodeAndProcess_StartDateBetweenAndCompletedIsFalse(String activityCode,
                                                                                              LocalDate startDate,
                                                                                              LocalDate endDate,
                                                                                              Pageable pageable);
}
