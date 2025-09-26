package pe.compendio.myandess.onboarding.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import pe.compendio.myandess.onboarding.entity.ProcessActivityContent;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface ProcessActivityContentRepository extends CrudRepository<ProcessActivityContent,Long> {
    int countByProcessActivity_Id(Long id);

  Optional<ProcessActivityContent> findByProcessActivity_IdAndContent_Id(Long id, Long contentId);

  List<ProcessActivityContent> findByResultIsNotNullAndProcessActivity_Process_StartDateBetween(LocalDate startDate, LocalDate endDate);
}
