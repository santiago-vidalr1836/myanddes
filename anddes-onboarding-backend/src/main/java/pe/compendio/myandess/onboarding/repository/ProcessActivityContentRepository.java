package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContent;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcessActivityContentRepository extends JpaRepository<ProcessActivityContent,Long> {
    int countByProcessActivity_Id(Long id);

  Optional<ProcessActivityContent> findByProcessActivity_IdAndContent_Id(Long id, Long contentId);

  List<ProcessActivityContent> findByResultIsNotNullAndProcessActivity_Process_StartDateBetween(LocalDate startDate, LocalDate endDate);

  List<ProcessActivityContent> findByProcessActivity_Process_Id(Long processId);

  List<ProcessActivityContent> findByProcessActivity_Process_IdIn(List<Long> processIds);

  List<ProcessActivityContent> findByProcessActivity_IdIn(List<Long> processActivityIds);

  long countByProcessActivity_Process_Id(Long processId);

  @Query("select count(pac) from ProcessActivityContent pac " +
         "where pac.processActivity.process.id = :processId " +
         "and (pac.progress is not null or pac.result is not null)")
  long countCompletedByProcessId(@Param("processId") Long processId);
}
